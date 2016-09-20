#!/apollo/sbin/envroot "$ENVROOT/bin/rubyenv" ruby

require 'optparse'

# formats brazil-build/junit output into a human-readable format
# use: bazil-build | <path_to>/junitFormat.rb
# docs at: https://w.amazon.com/index.php/EnvImprovementNinjas/JunitFormat

# Helper methods to add color to the output
def colorize(text, color_code)
  return text unless $colorize
  "#{color_code}#{text}\033[0m"
end

def red(text); colorize(text, "\033[31m"); end
def green(text); colorize(text, "\033[32m"); end

# states
tests = 0 # keeping track of tests seen
failures = 0
errors = 0

@test_count = 0
@failure_count = 0
@error_count = 0

@current_class = ""
@current_test = ""

@buffer_content = "" # content to print
@buffer_state = :passed # state of the buffer
@error_details = {} # {:class => {:test => :stack}}

class BaseFormatter
  
  def write_test(state, content)
    # no-op
  end

  def write_class(class_name)
    # no-op
  end

  def write_summary(tests, failures, errors)
    # no-op
  end

end

class DefaultFormatter < BaseFormatter
  
  def write_test(state, content)
    print state == :passed ? "[+] #{green(content)}" : "[FAIL] #{red(content)}"
  end

  def write_class(class_name)
    puts "#{class_name}"
  end

end

class RSpecFormatter < BaseFormatter
  
  def write_test(state, content)
    case state
    when :passed
        print green(".")
    when :failure
        print red("F")
    when :error
        print red("E")
    end
  end

  def write_summary(tests, failures, errors)
    print "\nTests: #{tests} Failures: #{failures} Errors: #{errors}"
  end
end

def flush_buffer
  unless @buffer_content.empty?
    $formatter.write_test(@buffer_state, @buffer_content)
    STDOUT.flush
    @buffer_content = ""
  end
  @buffer_state = :passed # default to green
end

def record_error
    content = ""
    begin
      fline = ARGF.readline
      content << fline.gsub(/\[junit\]/, "")
    end until fline =~ /\[junit\]\s+$/
    
    @error_details[@current_class] = {} unless @error_details[@current_class] # init
    @error_details[@current_class][@current_test] = content
end

$colorize = true
$formatter = DefaultFormatter.new
opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{$PROGRAM_NAME} [options]"
  opts.separator ""
  opts.separator "Specific options:"
  opts.on("--disableColorize", "Shut off colorization.  Colorization puts control codes in the output that some renderers don't recognize.  If omitted, colorize is true.") do |v|
    $colorize = false
  end

  opts.on("--format OPT", [:rspec, :default], "Change the output format. [rspec, default]") do |v|
    case v
    when :rspec
      $formatter = RSpecFormatter.new
    end
  end

  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end

opt_parser.parse!(ARGV)

line = ""
while(true) do

  begin
    last_line = line
    line = ARGF.readline
  rescue EOFError
    # done
    flush_buffer
    $formatter.write_summary(@test_count, @failure_count, @error_count)

    puts "\n\n"
    print "BUILD STATUS: "
    print last_line =~ /BUILD SUCCEEDED/ ? green(last_line) : red(last_line)
    puts ""

    break
  end

  if line =~ /\[junit\] Testsuite:/
      flush_buffer

      # new suite
      raise("missed some test/failure/error") unless (tests + failures + errors) == 0
      @current_class = line.split(" ").last
      $formatter.write_class("#{@current_class}")
  end

  if line =~ /\[junit\] Tests run:/
      # testsuite summary
      tests, failures, errors = line.scan(/\[junit\] Tests run: (\d+), Failures: (\d+), Errors: (\d+)/).first.collect{|a| a.to_i}
  
      @test_count += tests
      @failure_count += failures
      @error_count += errors
      # keeping track of tests and failures, to make sure that we find them all
      # in the logs
  end

  if line =~ /\[junit\] Testcase:/
      flush_buffer

      tests = tests - 1
      @current_test = line.scan(/\[junit\] Testcase: (.+?)\s/).first.first
      @buffer_content << "    #{@current_test}\n"
      
      if (tests == 0)
          # edge case; last test in the group. Print now, to get ahead of
          # STDERR; we can figure out pass/fail from the failures/errors counts
          @buffer_state = (failures + errors) > 0 ? :failure : :passed
          flush_buffer
      end
  end

  if line =~ /\[junit\]\s+FAILED/
      @buffer_state = :failure
      flush_buffer

      failures = failures - 1

      # read in the failure
      ARGF.readline # skip blank
      record_error
  end

  if line =~ /\[junit\]\s+Caused an ERROR/
      @buffer_state = :error
      flush_buffer

      errors = errors - 1
      record_error
  end
end

# make sure everything is printed
flush_buffer

# print error summary, if any
if (@error_details.any?)
    puts "\n\n"
    puts red("ERROR SUMMARY:")
    puts red("--------------")
    puts ""
    @error_details.keys.each do |error_class|
        @error_details[error_class].keys.each do |error_test|
            puts "#{error_class} :: #{error_test} :"
            puts red(@error_details[error_class][error_test])
            puts ""
        end
    end

    # and provide a non-zero exit status code
    Kernel.exit 1
else
    # success, no errors
    Kernel.exit 0
end

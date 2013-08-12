#!/usr/bin/perl

# Reads STDIN as 'Outlook CSV' (e.g. contacts exported from GMail webUI).
# Writes to STDOUT as mutt aliases
#
# Example usage:
#
# perl csv2muttalias.pl < contacts.csv >> ~/.muttrc

use strict;
use Text::CSV;

use constant FIRST_NAME  => "First Name";
use constant MIDDLE_NAME => "Middle Name";
use constant LAST_NAME   => "Last Name";
use constant TITLE       => "Title";
use constant EMAIL       => "E-mail Address";

use constant SPACER      => "    ";

# strips leading/trailing whitespace and ensures single space spacing
sub trim($);

# to store array indices of the fields we care about
my %columns = (
               &FIRST_NAME  => 0,
               &MIDDLE_NAME => 0,
               &LAST_NAME   => 0,
               &TITLE       => 0,
               &EMAIL       => 0
              );

# to hold parsed CSV data
my @rows;

my $csv = Text::CSV->new ({binary => 1})
  or die "Cannot use CSV:" . Text::CSV->error_dialog ();

# parse the header
my $fields = $csv->getline (*STDIN);

# parse everything else
while (my $row = $csv->getline (*STDIN))
{
    push @rows, $row;
}

# done parsing
$csv->eof or $csv->error_diag ();
$csv->eol ("\r\n");

# get the indices of the fields we care about
for my $i (0 .. $#{$fields})
{
    foreach my $key (keys %columns)
    {
        if ($fields->[$i] eq $key)
        {
            $columns{$key} = $i;
        }
    }
}

# write mutt aliases
foreach my $row (@rows)
{

    # skip contacts with blank e-mail address
    next if $row->[$columns{&EMAIL}] =~ m/^[\s]*$/;

    my $alias;

    # use either email or first name as the alias
    if ($row->[$columns{&FIRST_NAME}] =~ m/^[\s]*$/)
    {
        $alias = trim ($row->[$columns{&EMAIL}]);
        $alias =~ s/^([^@]+)@[^@]+$/\1/;
    }
    else
    {
        $alias = trim ($row->[$columns{&FIRST_NAME}]);
    }

    my $fullname =
      trim (  $row->[$columns{&FIRST_NAME}] . " "
            . $row->[$columns{&MIDDLE_NAME}] . " "
            . $row->[$columns{&LAST_NAME}]);

    # use a title only if the name is not blank
    if (!($fullname =~ m/^[\s]*$/))
    {
        $fullname = trim ($row->[$columns{&TITLE}] . " " . $fullname);
    }

    print "alias" 
      . &SPACER 
      . $alias 
      . &SPACER
      . $fullname
      . &SPACER . "<"
      . trim ($row->[$columns{&EMAIL}]) . ">" . "\n";
}

# strips leading/trailing whitespace and ensures single space spacing
sub trim ($)
{
    my $string = shift;

    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    $string =~ s/\s+/ /g;

    return $string;
}

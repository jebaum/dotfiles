#!/usr/bin/python
import sys
import re

if len(sys.argv) != 2:
  print ("Please provide an input file")
  sys.exit()

colors = dict()
colors[0]='#121212'
colors[1]='#DC322F'
colors[2]='#859900'
colors[3]='#FD971F'
colors[4]='#268BD2'
colors[5]='#FF33CC'
colors[6]='#33CC99'
colors[7]='#EEE8D5'
colors[8]='#555753'
colors[9]='#E84F4F'
colors[10]='#99FF66'
colors[11]='#E1AA5D'
colors[12]='#6699FF'
colors[13]='#FF66FF'
colors[14]='#93A1A1'
colors[15]='#FDF6E3'
colors[16]='#000000'
colors[17]='#00005F'
colors[18]='#000087'
colors[19]='#0000AF'
colors[20]='#0000D7'
colors[21]='#0000FF'
colors[22]='#005F00'
colors[23]='#005F5F'
colors[24]='#005F87'
colors[25]='#005FAF'
colors[26]='#005FD7'
colors[27]='#005FFF'
colors[28]='#008700'
colors[29]='#00875F'
colors[30]='#008787'
colors[31]='#0087AF'
colors[32]='#0087D7'
colors[33]='#0087FF'
colors[34]='#00AF00'
colors[35]='#00AF5F'
colors[36]='#00AF87'
colors[37]='#00AFAF'
colors[38]='#00AFD7'
colors[39]='#00AFFF'
colors[40]='#00D700'
colors[41]='#00D75F'
colors[42]='#00D787'
colors[43]='#00D7AF'
colors[44]='#00D7D7'
colors[45]='#00D7FF'
colors[46]='#00FF00'
colors[47]='#00FF5F'
colors[48]='#00FF87'
colors[49]='#00FFAF'
colors[50]='#00FFD7'
colors[51]='#00FFFF'
colors[52]='#5F0000'
colors[53]='#5F005F'
colors[54]='#5F0087'
colors[55]='#5F00AF'
colors[56]='#5F00D7'
colors[57]='#5F00FF'
colors[58]='#5F5F00'
colors[59]='#5F5F5F'
colors[60]='#5F5F87'
colors[61]='#5F5FAF'
colors[62]='#5F5FD7'
colors[63]='#5F5FFF'
colors[64]='#5F8700'
colors[65]='#5F875F'
colors[66]='#5F8787'
colors[67]='#5F87AF'
colors[68]='#5F87D7'
colors[69]='#5F87FF'
colors[70]='#5FAF00'
colors[71]='#5FAF5F'
colors[72]='#5FAF87'
colors[73]='#5FAFAF'
colors[74]='#5FAFD7'
colors[75]='#5FAFFF'
colors[76]='#5FD700'
colors[77]='#5FD75F'
colors[78]='#5FD787'
colors[79]='#5FD7AF'
colors[80]='#5FD7D7'
colors[81]='#5FD7FF'
colors[82]='#5FFF00'
colors[83]='#5FFF5F'
colors[84]='#5FFF87'
colors[85]='#5FFFAF'
colors[86]='#5FFFD7'
colors[87]='#5FFFFF'
colors[88]='#870000'
colors[89]='#87005F'
colors[90]='#870087'
colors[91]='#8700AF'
colors[92]='#8700D7'
colors[93]='#8700FF'
colors[94]='#875F00'
colors[95]='#875F5F'
colors[96]='#875F87'
colors[97]='#875FAF'
colors[98]='#875FD7'
colors[99]='#875FFF'
colors[100]='#878700'
colors[101]='#87875F'
colors[102]='#878787'
colors[103]='#8787AF'
colors[104]='#8787D7'
colors[105]='#8787FF'
colors[106]='#87AF00'
colors[107]='#87AF5F'
colors[108]='#87AF87'
colors[109]='#87AFAF'
colors[110]='#87AFD7'
colors[111]='#87AFFF'
colors[112]='#87D700'
colors[113]='#87D75F'
colors[114]='#87D787'
colors[115]='#87D7AF'
colors[116]='#87D7D7'
colors[117]='#87D7FF'
colors[118]='#87FF00'
colors[119]='#87FF5F'
colors[120]='#87FF87'
colors[121]='#87FFAF'
colors[122]='#87FFD7'
colors[123]='#87FFFF'
colors[124]='#AF0000'
colors[125]='#AF005F'
colors[126]='#AF0087'
colors[127]='#AF00AF'
colors[128]='#AF00D7'
colors[129]='#AF00FF'
colors[130]='#AF5F00'
colors[131]='#AF5F5F'
colors[132]='#AF5F87'
colors[133]='#AF5FAF'
colors[134]='#AF5FD7'
colors[135]='#AF5FFF'
colors[136]='#AF8700'
colors[137]='#AF875F'
colors[138]='#AF8787'
colors[139]='#AF87AF'
colors[140]='#AF87D7'
colors[141]='#AF87FF'
colors[142]='#AFAF00'
colors[143]='#AFAF5F'
colors[144]='#AFAF87'
colors[145]='#AFAFAF'
colors[146]='#AFAFD7'
colors[147]='#AFAFFF'
colors[148]='#AFD700'
colors[149]='#AFD75F'
colors[150]='#AFD787'
colors[151]='#AFD7AF'
colors[152]='#AFD7D7'
colors[153]='#AFD7FF'
colors[154]='#AFFF00'
colors[155]='#AFFF5F'
colors[156]='#AFFF87'
colors[157]='#AFFFAF'
colors[158]='#AFFFD7'
colors[159]='#AFFFFF'
colors[160]='#D70000'
colors[161]='#D7005F'
colors[162]='#D70087'
colors[163]='#D700AF'
colors[164]='#D700D7'
colors[165]='#D700FF'
colors[166]='#D75F00'
colors[167]='#D75F5F'
colors[168]='#D75F87'
colors[169]='#D75FAF'
colors[170]='#D75FD7'
colors[171]='#D75FFF'
colors[172]='#D78700'
colors[173]='#D7875F'
colors[174]='#D78787'
colors[175]='#D787AF'
colors[176]='#D787D7'
colors[177]='#D787FF'
colors[178]='#D7AF00'
colors[179]='#D7AF5F'
colors[180]='#D7AF87'
colors[181]='#D7AFAF'
colors[182]='#D7AFD7'
colors[183]='#D7AFFF'
colors[184]='#D7D700'
colors[185]='#D7D75F'
colors[186]='#D7D787'
colors[187]='#D7D7AF'
colors[188]='#D7D7D7'
colors[189]='#D7D7FF'
colors[190]='#D7FF00'
colors[191]='#D7FF5F'
colors[192]='#D7FF87'
colors[193]='#D7FFAF'
colors[194]='#D7FFD7'
colors[195]='#D7FFFF'
colors[196]='#FF0000'
colors[197]='#FF005F'
colors[198]='#FF0087'
colors[199]='#FF00AF'
colors[200]='#FF00D7'
colors[201]='#FF00FF'
colors[202]='#FF5F00'
colors[203]='#FF5F5F'
colors[204]='#FF5F87'
colors[205]='#FF5FAF'
colors[206]='#FF5FD7'
colors[207]='#FF5FFF'
colors[208]='#FF8700'
colors[209]='#FF875F'
colors[210]='#FF8787'
colors[211]='#FF87AF'
colors[212]='#FF87D7'
colors[213]='#FF87FF'
colors[214]='#FFAF00'
colors[215]='#FFAF5F'
colors[216]='#FFAF87'
colors[217]='#FFAFAF'
colors[218]='#FFAFD7'
colors[219]='#FFAFFF'
colors[220]='#FFD700'
colors[221]='#FFD75F'
colors[222]='#FFD787'
colors[223]='#FFD7AF'
colors[224]='#FFD7D7'
colors[225]='#FFD7FF'
colors[226]='#FFFF00'
colors[227]='#FFFF5F'
colors[228]='#FFFF87'
colors[229]='#FFFFAF'
colors[230]='#FFFFD7'
colors[231]='#FFFFFF'
colors[232]='#080808'
colors[233]='#121212'
colors[234]='#1C1C1C'
colors[235]='#262626'
colors[236]='#303030'
colors[237]='#3A3A3A'
colors[238]='#444444'
colors[239]='#4E4E4E'
colors[240]='#585858'
colors[241]='#626262'
colors[242]='#6C6C6C'
colors[243]='#767676'
colors[244]='#808080'
colors[245]='#8A8A8A'
colors[246]='#949494'
colors[247]='#9E9E9E'
colors[248]='#A8A8A8'
colors[249]='#B2B2B2'
colors[250]='#BCBCBC'
colors[251]='#C6C6C6'
colors[252]='#D0D0D0'
colors[253]='#DADADA'
colors[254]='#E4E4E4'
colors[255]='#EEEEEE'

inputfile = open(str(sys.argv[1]))
file_text = inputfile.readlines()

# reference matched group: \g<1>
for i in range(0, (len(file_text))):
  clean      = re.sub("\s+gui.*", "", file_text[i])
  ctermfgnum = re.search("ctermfg=(\w*\d*)", file_text[i])
  ctermbgnum = re.search("ctermbg=(\w*\d*)", file_text[i])
  cterm      = re.search("cterm=(\w*)", file_text[i])

  # final = str(clean)[:-1] + "  guifg=" + colors[int(ctermfgnum.group(1))]
  final =  str(clean).replace('\n','')

  if ctermfgnum:
    if str(ctermfgnum.group(1)).lower() == 'none' :
      final += "  guifg=NONE"
    else:
      final += "  guifg=" + colors[int(ctermfgnum.group(1))]

  if ctermbgnum:
    if str(ctermbgnum.group(1)).lower() == 'none' :
      final += "  guibg=#000000"
    else:
      final += "  guibg=" + colors[int(ctermbgnum.group(1))]

  if cterm:
    final += "  gui=" + str(cterm.group(1))

  print(final)

inputfile.close()

require 'win32ole'
$col_map =["","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
class Excel_Info
attr_accessor :file_name
attr_accessor :range
def initialize(file_name)
@file_name = file_name
@range = {}
end
end

def load_data(filename)
obj = nil
File.open(filename, "rb") {|f| obj = Marshal.load(f)}
return obj
end

def save_data(obj, filename)
File.open(filename, "wb") {|f| Marshal.dump(obj, f)}
end

def get_range_name(row, col)
return "ERR" if (col < 1) || (row < 1) || (col > 26 * 27) || (row > 65536)
c2 = col % 26
c2 = 26 if c2 == 0
c1 = (col - c2) / 26
return $col_map[c2] + row.to_s if c1 == 0
return $col_map[c1] + $col_map[c2] + row.to_s
end

def read_excel(e_name, s_name)
$excel.WorkBooks.Open(e_name)
$excel.WorkSheets(s_name).Activate
$excel_info = Excel_Info.new(e_name)
rows = $max_rows
cols = $max_cols
rows = $excel.WorkSheets(s_name).UsedRange.Rows.Count if rows == 0
for row in 1..rows
for col in 1..cols
$excel_info.range[get_range_name(row, col)] = $excel.Cells(row, col).value.to_s
end
end

$excel.WorkBooks.Close()
end

$MY_LOCATION = Dir.getwd
$excel = WIN32OLE.new("excel.application")
$excel.Visible = false
$max_cols = 2
$max_rows = 0
read_excel("F:\55_20110530125201.xls","55_20110530125201")
save_data($excel_info, "excel_info.obj")
info = load_data("excel_info.obj")
puts info.file_name
puts info.range["A1"]
puts info.range["A2"]
puts info.range["B1"]
puts info.range["B2"]
$excel.Quit()


# coding: utf-8
require 'csv'
class CsvSaver
  def self.edit_header(filename, new_headers)
    existing_data = []
    existing_data = CSV.read(filename, headers: true) if File.exist?(filename)

    new_header_row = new_headers

    CSV.open(
      filename,
      'w',
      write_headers: true,
      headers: new_header_row
    )  do |csv|
    end

    CSV.open(
      filename,
      'a',
    ) do |csv|
      existing_data.each do |row|
        csv << row
      end
    end
  end

  # 同じ日付(先頭要素)が存在したらそのうち最終行のみ残す
  def self.uniq(filename)
    return unless File.exist?(filename)

    csv_data = CSV.read(filename, headers: false)
    header = csv_data.shift

    # 先頭要素でグループ化し、各グループの最後の要素を取得
    result =
      csv_data
        .group_by { |row| row.first } # 行頭が日付になっている
        .transform_values(&:last)
        .values

    CSV.open(
      filename,
      'w',
      write_headers: true,
      headers: header
    )  do |csv|
    end
    CSV.open(
      filename,
      'a',
    ) do |csv|
      result.each do |row|
        csv << row
      end
    end
  end

  def self.append(filename, insert_row_data)
    file_exist = File.exist?(filename)

    # 既存の列名を取得
    existing_columns = []
    if file_exist
      csv = CSV.read(filename, headers: true)
      existing_columns = csv.headers
    end

    new_columns = insert_row_data.keys.map(&:to_s)
    existing_columns.concat(new_columns).uniq!

    self.edit_header(filename, existing_columns)

    CSV.open(
      filename,
      'a',
      headers: existing_columns
    ) do |csv|
      row = {}
      existing_columns.each do |key|
        insert_row_data.each do |item|
          if item[0] == key
            row[key] = item[1]
          else
            row[key] = row[key] || nil
          end
        end
      end
      csv << row
    end
  end
  def self.run(filename, insert_row_data)
    self.append(filename, insert_row_data)
    self.uniq(filename)
  end
  def self.test()
    data1 = {"a" => "1", "b" => "3", "c" => "4"}
    data2 = {"b" => "1", "c" => "3", "d" => "4"}
    self.append("test.csv", data1)
    self.append("test.csv", data2)
  end
end

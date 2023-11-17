class HomeController < ApplicationController
  require "csv"
  def summary
    csv_data = CSV.read("csv/summary_file.csv", headers: true)
    respond_to do |format|
      format.html do
      end 
      format.csv do
        send_data(csv_data, filename: "summary_file.csv", type: :csv)
      end
    end
  end
  def page_rank
    csv_data = CSV.read("csv/page_rank_file.csv", headers: true)
    respond_to do |format|
      format.html do
      end 
      format.csv do
        send_data(csv_data, filename: "page_rank_file.csv", type: :csv)
      end
    end
  end
  def link_rank
    csv_data = CSV.read("csv/link_rank_file.csv", headers: true)
    respond_to do |format|
      format.html do
      end 
      format.csv do
        send_data(csv_data, filename: "link_rank_file.csv", type: :csv)
      end
    end
  end
end

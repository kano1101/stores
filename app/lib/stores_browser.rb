# coding: utf-8
class StoresBrowser
  LOGIN_URL = 'https://id.stores.jp/login'
  DASHBOARD_URL = 'https://dashboard.stores.jp/analytics'

  START_DATE = Date.new(2019, 6, 1)
  END_DATE = Date.today

  SUMMARY_FILE = "csv/summary_file.csv"
  PAGE_RANK_FILE = "csv/page_rank_file.csv"
  LINK_RANK_FILE = "csv/link_rank_file.csv"

  def self.run()
    browser = self.browser_new()
    self.login(browser)
    self.scrape_and_save_csv(browser)
  end
  def self.run_on_mac()
    browser = self.browser_new_on_mac()
    self.login(browser)
    self.scrape_and_save_csv(browser)
  end
  def self.scrape_and_save_csv(browser)
    summary_data = {}
    summary_data["日付"] = Date.today()
    self.scrape_summary(browser).each do |item|
      summary_data[item[:text]] = item[:number]
    end
    CsvSaver.run(SUMMARY_FILE, summary_data)

    page_rank_data = {}
    page_rank_data["日付"] = Date.today()
    self.scrape_page_rank(browser).each do |key, value|
      page_rank_data[key] = value
    end
    CsvSaver.run(PAGE_RANK_FILE, page_rank_data)

    link_rank_data = {}
    link_rank_data["日付"] = Date.today()
    self.scrape_link_rank(browser).each do |item|
      link_rank_data[item[:text]] = item[:number]
    end
    CsvSaver.run(LINK_RANK_FILE, link_rank_data)

    browser.close
    exit
  end

  def self.browser_new()
    # Google Chromeへのパスを指定
    chrome_path = '/opt/google/chrome/google-chrome'
    # WatirでGoogle Chromeを起動
    browser = Watir::Browser.new(
      :chrome,
      options: {
        binary: chrome_path,
        args: %w[--headless --disable-gpu],
      }
    )
    browser
  end
  def self.browser_new_on_mac()
    # Google Chromeへのパスを指定
    chrome_path = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
    # WatirでGoogle Chromeを起動
    browser = Watir::Browser.new(
      :chrome,
      options: {
        binary: chrome_path,
        args: %w[--headless --disable-gpu],
      }
    )
    browser
  end

  def self.login(browser)
    browser.goto(LOGIN_URL)
    browser.text_field(id: 'email').set(ENV['STORES_USERNAME'])
    browser.wait
    browser.text_field(id: 'current-password').set(ENV['STORES_PASSWORD'])
    browser.wait
    browser.button(value: 'ログイン', data_testid: 'login-button').click
    browser.wait_until { browser.title.start_with?('ホーム - STORES') }
    browser.goto(DASHBOARD_URL)
    browser.wait_until { browser.title.start_with?('アクセス解析 - STORES') }
    p browser.title
    browser
  end

  def self.scrape_summary(browser)
    page_view = browser.sections[0].p(class: "num").inner_text
    page_view_diff = browser.sections[0].p(class: "diff").span.inner_text
    visitor = browser.sections[1].p(class: "num").inner_text
    visitor_diff = browser.sections[1].p(class: "diff").span.inner_text
    new_visitor = browser.sections[2].p(class: "num").inner_text
    new_visitor_diff = browser.sections[2].p(class: "diff").span.inner_text

    summary = [
      { text: "閲覧数", number: page_view },
      { text: "閲覧数差分", number: page_view_diff },
      { text: "訪問者数", number: visitor },
      { text: "訪問者数差分", number: visitor_diff },
      { text: "新規訪問者数", number: new_visitor },
      { text: "新規訪問者数差分", number: new_visitor_diff },
    ]

    device = []

    device_list =
      browser
        .div(class: "devices-wrapper")
        .ol(class: "devices_list")
        .lis(class: "devices_list_item")

    4.times do |n|
      device[n] = {
        text: device_list[n].ps[0].inner_text,
        number: device_list[n].ps[1].inner_text,
      }
    end

    result = [summary, device].reduce([], :+)
    result
  end

  def self.scrape_page_rank(browser)
    page_rank = []
    link = []

    page_list =
      browser
        .div(class: "page_ranking")
        .divs(class: "image_box_container")

    4.times do |n|
      span = page_list[n].span(class: "text")
      text = span.inner_text if span.exists?
      text = page_list[n].img.attribute('alt') if page_list[n].img.exists?
      page_rank[n] = {
        text: text,
        number: page_list[n].span(class: "count").inner_text,
      }
    end

    following_page_list =
      browser
        .div(class: "page_ranking")
        .div(class: "analytics_data_list")
        .dls

    following_page_list.each_with_index do |following_page, i|
      page_rank[i + 4] = {
        text: following_page.a.inner_text,
        number: following_page.dd.inner_text,
      }
    end

    sum = {}

    page_rank.each do |item|
      text = item[:text]
      num = item[:number].to_i

      if sum[text]
        sum[text] += num
      else
        sum[text] = num
      end
    end

    result = sum
    result
  end

  def self.scrape_link_rank(browser)
    link_rank = []
    link_list =
      browser
        .div(class: "analytics_column")
        .ul(class: "referrer_list")
        .lis(class: "referrer")
    (1..10).each_with_index do |_, i|
      link_rank[i] = {
        text: link_list[i].p(class: "name").inner_text,
        number: link_list[i].p(class: "count").inner_text,
      }
    end
    result = link_rank
    result
  end
end

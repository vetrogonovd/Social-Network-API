class LinkParser
  require 'nokogiri'
  require 'open-uri'
  require 'openssl'

  def self.parse(url)
    begin
      content = open(url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE, 'User-Agent' => 'opera')
      uri = URI.parse(url)
      # doc = Nokogiri::HTML(content, nil, 'UTF-8')
      doc = Nokogiri::HTML(content.read)
      doc.encoding = 'utf-8'
      page_info = {}
      page_info[:meta_title] = parse_title(doc)
      page_info[:meta_description] = parse_description(doc)
      page_info[:meta_image] = correct_url(parse_image(doc), uri)
      page_info[:meta_link] = url
      page_info
    rescue Exception
      page_info = 'Bad URL, please check it'
    end
  end

  def self.parse_title(doc)
    !doc.at('meta[property="og:title"]').nil? ? doc.at('meta[property="og:title"]')['content'] : doc.title
  end

  def self.parse_description(doc)
    meta_description = nil
    if !doc.at('meta[property="og:description"]').nil?
      meta_description = doc.at('meta[property="og:description"]')['content']
    elsif !doc.at('meta[name="description"]').nil?
      meta_description = doc.at('meta[name="description"]')['content']
    end
    meta_description
  end

  def self.parse_image(doc)
    if !doc.at('meta[property="og:image"]').nil?
      meta_image =  doc.at('meta[property="og:image"]')['content']
    else
      meta_image = doc.xpath('//img').map { |node| node.attribute('src').to_s.match('.*\.jpe?g') }.compact.first.to_s
    end
    meta_image
  end

  def self.correct_url(content, uri)
    result = content
    if content != '' && content != nil
      unless content =~ /http:\/\/|https:\/\//
        result = uri.scheme + "://" + uri.host + content
      end
    end
    result
  end

  private_class_method :parse_title, :parse_description, :parse_image, :correct_url
end
require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)

    doc.css(".student-card").each_with_object([]) do | student, array |
      student_hash = {
        name: student.css(".student-name").text,
        location: student.css(".student-location").text,
        profile_url: student.css("a").attribute("href").value
      }
      array << student_hash
    end
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html).css(".main-wrapper")

    student = {}

    social_links = doc.css(".social-icon-container a").map() do | link |
      link.attribute("href").value()
    end

    social_links.each() do | link |
        if link.include?("twitter")
          student[:twitter] = link
        elsif link.include?("linkedin")
          student[:linkedin] = link
        elsif link.include?("github")
          student[:github] = link
        else
          student[:blog] = link
        end
    end

    student[:profile_quote] = doc.css(".profile-quote").text
    student[:bio] = doc.css(".bio-content .description-holder p").text

    student
  end

end

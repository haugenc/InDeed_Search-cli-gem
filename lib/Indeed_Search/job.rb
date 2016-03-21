require "socket"
require "nokogiri"
require "open-uri"
require "pry"
class IndeedSearch::Job
  attr_accessor :title, :company, :location, :url, :posted_relative, :description
  @@all = []
  def self.all
    @@all
  end

  def self.clear_all
    @@all = []
  end


  def self.search(zip = 10001, search_terms = ["Ruby"])
    doc = Nokogiri::XML(open(self.create_url(zip,search_terms)))
    self.parse_results(doc.search("result"))
  end

  def self.create_url(zip,search_items)
    ip = self.get_ip
    "http://api.indeed.com/ads/apisearch?publisher=8941915765129427&q=#{search_items.join("+")}&l=#{zip}&sort=&radius=&st=&jt=&start=&limit=&fromage=&filter=&latlong=1&co=us&chnl=&userip=#{ip}&useragent=Mozilla/%2F4.0%28Firefox%29&v=2"
  end

  def self.get_ip
    ip = Socket::ip_address_list.detect do |address_object|
     address_object.ipv4? and !address_object.ipv4_loopback? and !address_object.ipv4_multicast?
    end
    ip.ip_address
  end

  def self.parse_results(doc)
    doc.each do |job|
      new_job = self.new
      new_job.title = job.search("jobtitle").text
      new_job.company = job.search("company").text
      new_job.location = job.search("formattedLocation").text
      new_job.posted_relative = job.search("formattedRelativeTime").text
      new_job.url = job.search("url").text
      #description = Nokogiri::HTML(open(new_job.url)).search("#job_summary").text
      new_job.description = job.search('snippet').text
      self.all << new_job
    end
  end

end

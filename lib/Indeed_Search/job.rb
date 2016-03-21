require "socket"
require "pry"
class IndeedSearch::Job
  attr_accessor :title, :company, :location, :url, :posted_relative, :description
  @@all = []
  def self.all
    # job_1 = self.new
    # job_1.title = "Dentist"
    # job_1.company = "Correct Care Solutions"
    # job_1.location = "Little Rock, AR"
    # job_1.url = "http://www.indeed.com/viewjob?jk=6a002e213d34d8a7&qd=j484ADII0CWZf_O5DvPlXYYJZ19en-aj46a9TrBCgkaTwdr4oGnGIBbZvtmkQGjY_6vbuPYFPRLrL5M99NCLQZKjcEF0HjbyB0nx0Px_6lQ&indpubnum=8941915765129427&atk=1aeb8al51a55i82s"
    # job_1.posted_relative = "30 days ago"
    # job_1.description = "Current licensure as a Dentist within the State. Our Dentists provide the dental services to inmate patients...."
    #
    # job_2 = self.new
    # job_2.title = "General Dentist – DDS / DMD (General Dental Practice)"
    # job_2.company = "Aspen Dental"
    # job_2.location = "Little Rock, AR"
    # job_2.url = "http://www.indeed.com/viewjob?jk=1e4a4fee1881ae72&qd=j484ADII0CWZf_O5DvPlXYYJZ19en-aj46a9TrBCgkaTwdr4oGnGIBbZvtmkQGjY_6vbuPYFPRLrL5M99NCLQZKjcEF0HjbyB0nx0Px_6lQ&indpubnum=8941915765129427&atk=1aeb8al51a55i82s"
    # job_2.posted_relative = "4 days ago"
    # job_2.description = "Aspen Dental-branded practices are independently owned and operated by licensed dentists. As a dentist, you'll have clinical autonomy and be able to focus your..."
    #
    # [job_1, job_2]
    @@all
  end

  def self.search(zip = 10001, search_terms = [])
    self.create_url(zip,search_terms)
  end

  def self.create_url(zip,search_items)
    ip = Socket.ip_address_list
    "http://api.indeed.com/ads/apisearch?publisher=8941915765129427&q=#{search_items.join("+")}&l=#{zip}&sort=&radius=&st=&jt=&start=&limit=&fromage=&filter=&latlong=1&co=us&chnl=&userip=#{ip[0]||"127.0.0.1"}&useragent=Mozilla/%2F4.0%28Firefox%29&v=2"
  end

  def self.get_ip
    Socket::ip_address_list.detect do |address_object|
     address_object.ipv4? and !address_object.ipv4_loopback? and !address_object.ipv4_multicast? and !address_object.ipv4_private?
   end
  end

end

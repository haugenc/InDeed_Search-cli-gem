require "launchy"

class IndeedSearch::Cli
  attr_accessor :zip, :search_terms, :jobs
  def call
    puts "\nWelcome to:\n"
    puts "\n _____     ______              _   _____                     _     "
    puts "|_   _|    |  _  \\            | | /  ___|                   | |    "
    puts "  | | _ __ | | | |___  ___  __| | \\ `--.  ___  __ _ _ __ ___| |__  "
    puts "  | || '_ \\| | | / _ \\/ _ \\/ _` |  `--. \\/ _ \\/ _` | '__/ __| '_ \\ "
    puts " _| || | | | |/ /  __/  __/ (_| | /\\__/ /  __/ (_| | | | (__| | | |"
    puts " \\___/_| |_|___/ \\___|\\___|\\__,_| \\____/ \\___|\\__,_|_|  \\___|_| |_|"

    menu
    goodbye
  end

  def menu
    input = ""
    get_zip
    get_search
    get_jobs
    list_jobs
    while input != "exit"
      puts "\nEnter the number of the job you would like more info on"
      puts "[job #, new, list, exit]:"
      input = gets.chomp.downcase
      case
      when input.to_i > 0 && input.to_i <= @jobs.length
        job = @jobs[input.to_i - 1]
        puts "\nJob Title:\t#{job.title}\nCompany:\t#{job.company}\nDescription:\t#{job.description}\nPosted:\t\t#{job.posted_relative}"
      when input == "exit"
      when input == "list"
        list_jobs
      when input == "new"
        clear_jobs
        input = menu
      when input.match(/^open /) && input.split[1].to_i > 0 && input.split[1].to_i <= @jobs.length
        Launchy.open(@jobs[input.split[1].to_i - 1].url)
      else
        puts "Invalid Selection. Please make a valid selection!"
      end
    end
    input
  end

  def get_zip
    puts "\nPlease enter a valid zipcode you would like to search:"
    @zip = gets.chomp
    @zip.match(/\d{5}/) ? @zip : get_zip
  end

  def get_search
    puts "\nPlease enter the search terms:"
    @search_terms = gets.chomp.split
    @search_terms.length > 0 ? @search_terms : get_search
  end

  def get_jobs
    IndeedSearch::Job.search(@zip,@search_terms)
  end

  def list_jobs
    @jobs = IndeedSearch::Job.all
    puts "\n#{@jobs.length == 10 ? "Top 10" : @jobs.length} Results:"
    @jobs.each.with_index(1) do |job, i|
      puts "#{i}. #{job.title} - #{job.company} - #{job.location}"
    end
  end
  def clear_jobs
    @jobs = nil
    IndeedSearch::Job.clear_all
  end

  def goodbye
    puts "\nThank you for using my gem.  Good luck with the job search!"
  end

end

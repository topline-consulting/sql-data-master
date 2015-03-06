class Bserver
  
  def initialize
    @@started = false
    @@pid = 0
  end
  
  def start
    if @@started
      self.stop
    end
    @@pid = Kernel.fork {
      system("ruby #{RAILS_ROOT}/script/backgroundrb/start&")
    }
    @@started = true
    #sleep 5.seconds
  end
  
  def stop
    if @@started
      @@pid = Kernel.fork {
        system("ruby #{RAILS_ROOT}/script/backgroundrb/stop&")
      }
      @@started = false
    end
  rescue
    
  end
  
end

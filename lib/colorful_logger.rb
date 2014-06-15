require 'term/ansicolor'
require 'logger'

class String
  include Term::ANSIColor
end

class ColorfulLogger < Logger

  def initialize(logdev, shift_age = 0, shift_size = 1048576)
    super(logdev, shift_age, shift_size)
    self.formatter = proc do |severity, datetime, progname, msg|
      pid_colored = ('%s#%d' % [ progname, $$]).to_s.dark.send([:red,:green,:cyan,:magenta,:yellow][$$%5])
      severity_colored = ("%5s" % severity).bold.send({"DEBUG"=>:cyan, "INFO"=>:white, "WARN"=>:yellow, "ERROR"=>:red, "FATAL"=>:red}[severity.to_s] || :magenta)
      "%s [%s] %s %s\n" % [datetime.strftime('%Y-%m-%d %H:%M:%S'), pid_colored, severity_colored, msg]
    end
  end

  def write(msg)
    self.info msg.chomp
  end

end

# Tweak the String base class to easily change console font style
# Edited from source: https://cbabhusal.wordpress.com/2015/10/02/ruby-printing-colored-formatted-character-in-ruby-colorize/
# Using ANSI escape characters
# https://en.wikipedia.org/wiki/ANSI_escape_code

class String
  # 38: foreground color
  def icon_white; "\e[38;2;#{255};#{255};#{255}m#{self}\e[0m" end
  def icon_black; "\e[38;2;#{0};#{0};#{0}m#{self}\e[0m" end

  def icon_orange; "\e[38;2;#{200};#{142};#{62}m#{self}\e[0m" end
  def icon_blue; "\e[38;2;#{0};#{157};#{255}m#{self}\e[0m" end 

  # 48: background color
  # Tip: choose light colors that are similar to each other so they maximize contrast with darker pieces
  # For an unknown reason, background color will change how the foreground icon will look. If "black" and "white" bg colors are very similar in color, the change on the foreground color will not be perceptive
  def background_light_grey; "\e[48;2;#{255};#{255};#{255}m#{self}\e[0m" end
  def background_dark_grey; "\e[48;2;#{230};#{230};#{230}m#{self}\e[0m" end
  
  def background_blue; "\e[48;2;#{17};#{168};#{205}m#{self}\e[0m" end
  def background_green; "\e[48;2;#{13};#{188};#{121}m#{self}\e[0m" end

end
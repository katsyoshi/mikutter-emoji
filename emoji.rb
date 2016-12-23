require 'yaml'

Plugin.create(:emoji) do
  on_boot do
    file_path = File.expand_path("./emoji.yml", __dir__)
    EMOJI = YAML.load_file(file_path) if File.exist? file_path
  end

  on_update  do |service, message|
    message.each do |msg|
      emoji_exchange(msg[:message])
    end
  end

  def emoji_exchange(msg)
    e_key = msg.match(/:(?<e_key>.+):/)[:e_key] rescue nil
    msg.gsub!(/:#{e_key}:/, EMOJI[e_key]) unless EMOJI[e_key].nil?
  rescue => e
    puts e.message
    msg
  end
end

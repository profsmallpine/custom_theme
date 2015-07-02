Whitelabel.class_eval do
  # Your new methods here
  def self.from_file(path)
    @labels = File.open(path) { |file| YAML.load(ERB.new(File.read(file)).result) }
  end
end

YourLabelClass = Struct.new :label_id, :some_config
Whitelabel.from_file Rails.root.join("config/whitelabel.yml.erb")

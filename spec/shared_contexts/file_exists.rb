# needs file and file_content defined
shared_context 'a file exists' do
  before :each do
    File.open(file, 'w') do |f|
      f.write file_content
    end
  end

  after :each do
    File.delete(file) if File.exist?(file)
  end
end

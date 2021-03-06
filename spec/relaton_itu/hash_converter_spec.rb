require "yaml"
require "jing"

RSpec.describe RelatonItu::HashConverter do
  it "creates IetfBibliographicItem form hash" do
    hash = YAML.load_file "spec/examples/itu_bib_item.yml"
    item = RelatonItu::ItuBibliographicItem.from_hash hash
    xml = item.to_xml bibdata: true
    file = "spec/examples/from_yaml.xml"
    File.write file, xml, encoding: "UTF-8" unless File.exist? file
    expect(xml).to be_equivalent_to File.read(file, encoding: "UTF-8")
      .sub %r{(?<=<fetched>)\d{4}-\d{2}-\d{2}}, Date.today.to_s
    schema = Jing.new "spec/examples/isobib.rng"
    errors = schema.validate file
    expect(errors).to eq []
  end
end

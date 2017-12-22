require "spec_helper"
require "fileutils"

FORMATTER_FILE_PATH = Pathname.new(File.dirname(__FILE__))

def assert_source_specs(source_specs)
  relative_path = Pathname.new(source_specs).relative_path_from(FORMATTER_FILE_PATH).to_s

  describe relative_path do
    tests = []
    current_test = nil

    File.foreach(source_specs).with_index do |line, index|
      case
      when line =~ /^#~# ORIGINAL ?(skip ?)?(\:focus ?)?(.*)$/
        # save old test
        tests.push current_test if current_test

        # start a new test

        skip = !!$~[1]
        focus = !!$~[2]
        name = $~[3].strip
        name = "unnamed test" if name.empty?

        current_test = {name: name, line: index + 1, options: {}, original: "",skip: skip,focus: focus}
      when line =~ /^#~# EXPECTED$/
        current_test[:expected] = ""
      when line =~ /^#~# (.+)$/
        current_test[:options] = eval("{ #{$~[1]} }")
      when current_test[:expected]
        current_test[:expected] += line
      when current_test[:original]
        current_test[:original] += line
      end
    end

    (tests + [current_test]).each do |test|
      it "formats #{test[:name]} (line: #{test[:line]})", focus: test[:focus] do
        skip if test[:skip]
        error = nil

        begin
          formatted = Roofie.format(test[:original], **test[:options]).to_s.strip
        rescue StandardError => e
          error = e
          formatted = ""
        end

        expected = test[:expected].strip

        if expected != formatted
          # message = "#{Rufi::Formatter.debug(test[:original], **test[:options])}\n\n" +
                    # "#{Rufi::Formatter.format(test[:original], **test[:options]).ai(index: false)}\n\n" +

          message = if test[:options].any?
                       "#~# OPTIONS\n\n" + test[:options].ai
                     else
                       ""
                     end

          message += "\n\n#~# ORIGINAL\n" +
                     test[:original] +
                     "#~# EXPECTED\n\n" +
                     expected +
                     "\n\n#~# ACTUAL\n\n" +
                     formatted +
                     "\n\n#~# INSPECT\n\n" +
                     formatted.inspect

          if error
            puts message
            fail error
          else
            fail message
          end
        end

        expect(formatted).to eq(expected)
      end
    end
  end
end

def assert_format(code, expected)
  it "formats #{code.inspect} to #{expected.inspect}" do
    expect(described_class.format(code)).to eq(expected)
  end
end

RSpec.describe Roofie::Formatter do
  describe "unknown code" do
    it "spits out code" do
      code = "def hi; end"

      expect(Roofie.format(code)).to eq code
    end

    it "formats a bigger chunk of code" do
      code = %(
        require "passion_pit"

        PassionPit.find_the_sea_of_love(1..10.to_a)
      )

      expect(Roofie.format(code).strip).to eq code.strip
    end

    it "formats an array" do
      code = "
        [1, 2, 3, 4, 5, 6]

          [1, 2,3]
      "

      expect(Roofie.format(code).strip).to eq code.strip
    end

    it "formats an assigment inside an unknown expression" do
      code = "def hi\n   wut()     \nend\n\n  z =  10"

      expect(Roofie.format(code).strip).to eq "def hi\n   wut()     \nend\n\nz = 10"
    end

    it "spits out this exact file" do
      code = File.read(__FILE__)

      expect(Roofie.format(code)).to eq code
    end
  end

  describe "source specs" do
    %w(
      assignment_literal
    ).each do |source_spec_name|
      file = File.join(FORMATTER_FILE_PATH, "..", "source_specs", "#{source_spec_name}.rb.spec")
      fail "missing #{source_spec_name}" unless File.exist?(file)
      assert_source_specs(file) if File.file?(file)
    end
  end
end

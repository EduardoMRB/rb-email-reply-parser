require "reply_parser"
require "spec_helper"

def email(key)
  File.open("spec/emails/email_#{key}.txt", "r").read
end

def expected_result(key)
  File.open("spec/expected/email_#{key}.txt", "r").read
end

describe ReplyParser do

  it "can parse a simple structure" do
    email = email("1_4")

    expect(ReplyParser.parse(email)).to eq("Awesome! I haven't had another problem with it.")
  end

  it "can parse a message with quotes in the middle" do
    email = email("1_2")

    result = ReplyParser.parse(email)

    expect(result).to include("You can list the keys for the bucket and call delete for each.")
    expect(result).not_to include("On Tue, 2011-03-01 at 18:02 +0530, Abhishek Kona wrote:")
  end

  it "can parse a message with blank lines in the beginning" do
    email = email("driftt_1")

    expect(ReplyParser.parse(email)).to eq("hey notifications!")
  end

  it "can handle multiline quote headers" do
    email = email("1_6")

    result = ReplyParser.parse(email)

    expect(result).to include("I get proper rendering as well.")
    expect(result).to include("Sent from a magnificent torch of pixels")
    expect(result).not_to include("On Dec 16, 2011, at 12:47 PM, Corey Donohoe")
  end
end

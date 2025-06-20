# frozen_string_literal: true

require "formula_creator"

RSpec.describe Homebrew::FormulaCreator do
  describe ".new" do
    tests = {
      "generic tarball URL":       {
        url:     "http://digit-labs.org/files/tools/synscan/releases/synscan-5.02.tar.gz",
        name:    "synscan",
        version: "5.02",
      },
      "gitweb URL":                {
        url:  "http://www.codesrc.com/gitweb/index.cgi?p=libzipper.git;a=summary",
        name: "libzipper",
      },
      "GitHub repo URL with .git": {
        url:         "https://github.com/Homebrew/brew.git",
        name:        "brew",
        head:        true,
        fetch:       true,
        github_user: "Homebrew",
        github_repo: "brew",
      },
      "GitHub archive URL":        {
        url:         "https://github.com/Homebrew/brew/archive/4.5.7.tar.gz",
        name:        "brew",
        version:     "4.5.7",
        fetch:       true,
        github_user: "Homebrew",
        github_repo: "brew",
      },
      "GitHub releases URL":       {
        url:         "https://github.com/stella-emu/stella/releases/download/6.7/stella-6.7-src.tar.xz",
        name:        "stella",
        version:     "6.7",
        fetch:       true,
        github_user: "stella-emu",
        github_repo: "stella",
      },
    }

    tests.each do |description, test|
      it "parses #{description}" do
        fetch = test.fetch(:fetch, false)
        allow(GitHub).to receive(:repository).with(test.fetch(:github_user), test.fetch(:github_repo)) if fetch

        formula_creator = described_class.new(url: test.fetch(:url), fetch:)

        expect(formula_creator.name).to eq(test.fetch(:name))
        if (version = test[:version])
          expect(formula_creator.version).to eq(version)
        else
          expect(formula_creator.version).to be_null
        end
        expect(formula_creator.head).to eq(test.fetch(:head, false))
      end
    end
  end
end

require "spec_helper"

module Accesslint
  module Ci
    describe Commenter do
      it "posts a comment to GitHub" do
        allow(RestClient).to receive(:get).
          with("https://accesslint-ci:ABC456@api.github.com/repos/accesslint/accesslint-ci.rb/pulls?head=accesslint:#{ENV.fetch('CIRCLE_BRANCH')}").
          and_return([ { number: 1 } ].to_json)
        allow(RestClient).to receive(:post)

        Commenter.perform(["my diff"])

        expect(RestClient).to have_received(:post).with(
          "https://accesslint-ci:ABC456@api.github.com/repos/accesslint/accesslint-ci.rb/issues/1/comments",
          { body: "Found 1 new accessibility issues: \n```\nmy diff\n```" }.to_json
        )
      end

      context "when CI_PULL_REQUEST is set" do
        it "uses the number from CI_PULL_REQUEST" do
          ENV["CI_PULL_REQUEST"] = "https://github.com/accesslint/accesslint-ci.rb/pull/9001"

          allow(RestClient).to receive(:post)

          Commenter.perform(["my diff"])

          expect(RestClient).to have_received(:post).with(
            "https://accesslint-ci:ABC456@api.github.com/repos/accesslint/accesslint-ci.rb/issues/9001/comments",
            { body: "Found 1 new accessibility issues: \n```\nmy diff\n```" }.to_json
          )

          ENV.delete("CI_PULL_REQUEST")
        end
      end

      context "when running on master" do
        it "uses the number from CI_PULL_REQUEST" do
          ENV["CI_PULL_REQUEST"] = "https://github.com/accesslint/accesslint-ci.rb/pull/9001"

          allow(RestClient).to receive(:post)

          Commenter.perform(["my diff"])

          expect(RestClient).to have_received(:post).with(
            "https://accesslint-ci:ABC456@api.github.com/repos/accesslint/accesslint-ci.rb/issues/9001/comments",
            { body: "Found 1 new accessibility issues: \n```\nmy diff\n```" }.to_json
          )

          ENV.delete("CI_PULL_REQUEST")
        end
      end
    end
  end
end

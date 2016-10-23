require "spec_helper"

module Accesslint
  module Ci
    describe Commenter do
      it "sends a comment to the accesslint service" do
        original_pull_request = ENV["CI_PULL_REQUEST"]
        ENV["CI_PULL_REQUEST"] = "https://github.com/accesslint/accesslint-ci/pull/9001"
        accesslint_service_url = "https://accesslint:ABC456@www.accesslint.com/api/v1/projects/accesslint/accesslint-ci/pulls/9001/comments"
        errors = ["new error"]
        body = {
          body: {
            errors: errors,
          }
        }.to_json
        allow(RestClient).to receive(:get)
        allow(RestClient).to receive(:post)

        Commenter.perform(errors)

        expect(RestClient).to have_received(:post).with(accesslint_service_url, body)
        ENV["CI_PULL_REQUEST"] = original_pull_request
      end
    end
  end
end

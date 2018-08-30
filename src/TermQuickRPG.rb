#!/usr/bin/env ruby
#encoding: utf-8

require_relative "TermQuickRPG/runner"

module TermQuickRPG
  def self.run
    Runner.new.run
  end
end

TermQuickRPG.run

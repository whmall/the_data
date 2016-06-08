require 'csv'
require 'the_data/table/config'
require 'the_data/table/import'
require 'the_data/table/export'

class TheData::Table
  include TheData::Import
  include TheData::Export

  attr_reader :data_list_id,
              :collection,
              :columns,
              :headers,
              :footers,
              :fields,
              :arguments

  # collection = -> { User.limit(10) }
  # columns = [:name, :email, :mobile]
  # headers = { name: 'My name'}
  # fields = { name: ->{name} },
  # footers = { }
  def initialize(data_list_id)
    @data_list_id = data_list_id
    @collection = nil
    @columns = []
    @headers = {}
    @footers = {}
    @fields = {}
    @arguments = {}
  end

  def collection_result
    collection.call
  end

  def config
    raise 'should call in subclass'
  end

  def inflector
    @inflector = TheData.config.inflector
  end

  def header_values
    @header_values = headers.values_at(*columns)
  end

  def footer_values
    @footer_values = footers.values_at(*columns)
  end

  def field_values
    @field_values = fields.values_at(*columns)
  end

  def self.config(*args)
    data_list_id = args.shift
    report = self.new(report_list_id)
    report.config(*args)
  end

  def self.to_table(*args)
    config(*args).to_table
  end

end
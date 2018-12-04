require 'securerandom'

module VerifiableView
  def verify
    VerifiableView.verification_method.call(
      code_view_definition,
      db_view_definition
    )
  end

  def definition(&block)
    @definition ||= block or raise "Missing view definition"
  end

  def self.verification_method=(some_proc)
    @verification_method = some_proc
  end

  private

  def code_view_definition
    view_name = "view_#{SecureRandom.hex(10)}"
    result = ""
    transaction do
      create_view(view_name)
      result = get_view_sql(view_name)
      raise ActiveRecord::Rollback
    end

    result
  end

  def db_view_definition
    get_view_sql(table_name)
  end

  def self.verification_method
    @verification_method || (lambda do |code_def, db_def|
      return true if db_def == code_def
      raise "The view definition in your DB doesn't match with your code" 
    end)
  end

  def create_view(name)
    definition_sql = definition.call.to_sql
    connection.execute("create view #{name} as #{definition_sql}")
  end
  
  def get_view_sql(view_name)
    connection.
      execute("select view_definition from information_schema.views
              where table_name = '#{view_name}'").
      first&.
      fetch("view_definition")
  end
end

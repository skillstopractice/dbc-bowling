class Contractor
  def self.for(description, &b)
    new(description, &b)
  end

  def self.disable_enforcement
    @conditions_disabled = true
  end

  def self.conditions_disabled?
    !! @conditions_disabled
  end

  def initialize(description, &task)
    @description = description
    @assumptions = []
    @assurances  = []
    @alterations = {}
    @context     = ""
  end

  def alters(name, &b)
    @alterations[name] = { action: b }

    self
  end

  alias_method :may_alter, :alters

  attr_reader :alterations

  def acknowledges(context)
    @context << "[#{context}]"

    self
  end

  def broken(message)
    raise message unless self.class.conditions_disabled?
  end

  def assumes(description, &b)
    @assumptions << [description, b]

    self
  end

  def ensures(description, &b)
    @assurances << [description, b]

    self
  end

  def work(*)
    return yield(*) if self.class.conditions_disabled?

    @assumptions.each do |description, condition|
      if @context != ""
        fail "Contract Violation - [when #{@context}] #{description} (in #{@description})" unless condition.call(*)
      else
        fail "Contract Violation - #{description} (in #{@description})" unless condition.call(*)
      end
    end

    @alterations.each do |message, diff|
      diff[:before] = diff[:action].call
    end

    result = yield(*)

    @alterations.each do |message, diff|
      diff[:after] = diff[:action].call
    end

    @assurances.each do |description, condition|
      if @context != ""
        fail "Contract Violation - #{@context} #{description} (in #{@description})" unless condition.call(result, alterations)
      else
        fail "Contract Violation - #{description} (in #{@description})" unless condition.call(result, alterations)
      end
    end

    result
  end
end

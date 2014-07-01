class Bomb
  attr_reader :state

  def initialize
    @activation_code = "1234"
    @deactivation_code = "0000"
    @state = :deactivated
    @deactivation_attempts = 0
  end

  def set_activation_code(code)
    @activation_code = code if valid_code?(code)
  end

  def set_deactivation_code(code)
    @deactivation_code = code if valid_code?(code)
  end

  def activate(code)
    return if state != :deactivated
    return if @activation_code != code

    @state = :activated
  end

  def deactivate(code)
    return if state != :activated

    if @deactivation_code != code
      update_deactivation_attempts if @deactivation_code != code
      explode_bomb if @deactivation_attempts == 3
      return
    end

    @state = :deactivated
  end

  private
  def valid_code?(code)
    code.length == 4 && code =~ /[[:digit:]]{4}/
  end

  def update_deactivation_attempts
    @deactivation_attempts += 1
  end
  
  def explode_bomb
    @state = :exploded
  end

end

class Bomb
  attr_reader :state

  def initialize
    @activation_code = "1234"
    @deactivation_code = "0000"
    @state = :deactivated
    @deactivation_attempts = 0
  end

  def activation_code(code)
    @activation_code = code if valid_code?(code)
  end

  def deactivation_code(code)
    @deactivation_code = code if valid_code?(code)
  end

  def activate(code)
    @state = :activated if (state == :deactivated) && (@activation_code == code)
  end

  def deactivate(code)
    if (state == :activated) && (@deactivation_code == code)
      @state = :deactivated
    else
      @deactivation_attempts += 1
      explode_bomb if @deactivation_attempts == 3
    end
  end

  private
  def valid_code?(code)
    code.length == 4 && code =~ /[[:digit:]]{4}/
  end

  def explode_bomb
    @state = :exploded
  end

end

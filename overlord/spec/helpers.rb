module Helpers
  def activation_code_set?(bomb, code)
    !!bomb.activate(code)
  end

  def deactivation_code_set?(bomb, code)
    allow(bomb).to receive(:state) { :activated }
    !!bomb.deactivate(code)
  end
end

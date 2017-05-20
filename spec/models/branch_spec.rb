require 'rails_helper'

RSpec.describe Branch, type: :model do
  let!(:branch) {
    Branch.create(
      name: "Sede salitre",
      email: "agutierrezt@unal.edu.co",
      password: "gutierrez2011",
      password_confirmation: "gutierrez2011",
      address: "Some directions in bogota",
      telephone: "3108003068"
    )
  }
  describe "Validations" do
    let(:branch_test) { Branch.new }
    it 'is not valid without attributes' do
      expect(branch_test).to_not be_valid
    end
    it 'is not valid, if the email is not unique' do
      branch_test.name = "Some sedes"
      branch_test.email = "agutierrezt@unal.edu.co"
      branch_test.password = "gutierrez2011",
      branch_test.password_confirmation = "gutierrez2011"
      branch_test.address = "Some directions in bogota"
      branch_test.telephone = "3118003068"
      expect(branch_test).to_not be_valid
    end
    it 'is not valid, if the name is not long enough' do
      branch_test.name = "s"
      branch_test.email = "agutierrezt1@unal.edu.cco"
      branch_test.password = "gutierrez2011",
      branch_test.password_confirmation = "gutierrez2011"
      branch_test.address = "Some directions in bogota"
      branch_test.telephone = "3118003068"
      expect(branch_test).to_not be_valid
    end
    it 'is not valid, if the telephone is not a number' do
      branch_test.name = "s"
      branch_test.email = "agutierrezt1@unal.edu.co"
      branch_test.password = "gutierrez2011",
      branch_test.password_confirmation = "gutierrez2011"
      branch_test.address = "Some directions in bogota"
      branch_test.telephone = "sdafasdf"
      expect(branch_test).to_not be_valid
    end
    it 'is not valid, if the telephone is not long enough' do
      branch_test.name = "s"
      branch_test.email = "agutierrezt1@unal.edu.co"
      branch_test.password = "gutierrez2011",
      branch_test.password_confirmation = "gutierrez2011"
      branch_test.address = "Some directions in bogota"
      branch_test.telephone = "311456"
      expect(branch_test).to_not be_valid
    end
    it 'is valid' do
      branch_test.name = "sede del notrte"
      branch_test.email = "agutierrezt1@unal.edu.co"
      branch_test.password = "gutierrez2011"
      branch_test.password_confirmation = "gutierrez2011"
      branch_test.address = "Some directions in bogota"
      branch_test.telephone = "3114565690"
      expect(branch_test).to be_valid
    end
  end
end

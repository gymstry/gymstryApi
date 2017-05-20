require 'rails_helper'

RSpec.describe Admin, type: :model do
  let!(:admin) {
    Admin.create(
      name: "Andres",
      username: "agutierrezt",
      email: "agutierrezt@unal.edu.co",
      password: "gutierrez2011",
      password_confirmation: "gutierrez2011"
    )
  }
  describe "Validations" do
    let (:admin_test) { Admin.new }
    it "is not valid without attributes" do
      expect(admin_test).to_not be_valid
    end

    it "is not valid, if the email is not unique" do
      admin_test.name = "Andres"
      admin_test.username = "andres930410"
      admin_test.password = "gutierrez2011"
      admin_test.password_confirmation = "gutierrez2011"
      admin_test.email = "agutierrezt@unal.edu.co"
      expect(admin_test).to_not be_valid
    end

    it "is not valid, if the username is not unique" do
      admin_test.name = "Andres"
      admin_test.username = "agutierrezt"
      admin_test.password = "gutierrez2011"
      admin_test.password_confirmation = "gutierrez2011"
      admin_test.email = "agutierrezt1@unal.edu.co"
      expect(admin_test).to_not be_valid
    end

    it "is valid, if the username and email are unique" do
      admin_test.name = "Andres"
      admin_test.username = "agutierrezt1"
      admin_test.password = "gutierrez2011"
      admin_test.password_confirmation = "gutierrez2011"
      admin_test.email = "agutierrezt1@unal.edu.co"
      expect(admin_test).to be_valid
    end
  end


end

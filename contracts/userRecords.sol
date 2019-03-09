/*
    Copyright 2019 Auroville Foundation, https://aurovillefoundation.org.in/

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/
pragma solidity ^0.5.5;

import "./StringUtils.sol";

contract userRecords {
    // enum type variable to store user gender
    enum genderType {male, female}

    // Actual user object which we will store in ethereum contract
    struct user {
        string name;
        genderType gender;
    }

    user user_obj;

    // set user public function
    // This is similar to persisting object in db.
    function setUser(string memory name, string memory gender) public {
        genderType gender_type = getGenderFromString(gender);
        user_obj = user({name: name, gender: gender_type});
    }

    // get user public function
    // This is similar to getting object from db.
    function getUser() public view returns (string memory, string memory) {
        return (user_obj.name, getGenderToString(user_obj.gender));
    }

    // Internal function to convert genderType enum from string
    function getGenderFromString(string memory gender)
        internal
        pure
        returns (genderType)
    {
        if (StringUtils.equal(gender, "male")) {
            return genderType.male;
        } else {
            return genderType.female;
        }
    }
    // Internal function to convert genderType enum to string
    function getGenderToString(genderType gender)
        internal
        pure
        returns (string memory)
    {
        if (gender == genderType.male) {
            return "male";
        } else {
            return "female";
        }
    }

}

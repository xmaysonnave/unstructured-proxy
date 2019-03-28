const { expect } = require('chai');

const AddressUtilMock = artifacts.require("AddressUtilMock");

contract("AddressUtil", function ([_, anyone]) {

    it("In constructor", async () => {
        const test = await AddressUtilMock.new({ from: anyone });
    });

    it("Not in constructor", async () => {
        const test = await AddressUtilMock.new({ from: anyone });
        expect(await test.notInConstructor()).to.equal(false);
    });

    it("Is not a contract", async () => {
        const test = await AddressUtilMock.new({ from: anyone });
        expect(await test.isNotContract()).to.equal(false);
    });

    it("Is a contract", async () => {
        const test = await AddressUtilMock.new({ from: anyone });
        expect(await test.isContract()).to.equal(true);
    });

});
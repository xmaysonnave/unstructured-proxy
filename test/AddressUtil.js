const AddressUtilMock = artifacts.require("AddressUtilMock");

contract("AddressUtil", function ([_, anyone]) {

    it("In constructor", async () => {
        const test = await AddressUtilMock.new({ from: anyone });
    });

    it("Not in constructor", async () => {
        const test = await AddressUtilMock.new({ from: anyone });
        (await test.notInConstructor()).should.be.equal(false);
    });

    it("Is not a contract", async () => {
        const test = await AddressUtilMock.new({ from: anyone });
        (await test.isNotContract()).should.be.equal(false);
    });

    it("Is a contract", async () => {
        const test = await AddressUtilMock.new({ from: anyone });
        (await test.isContract()).should.be.equal(true);
    });

});
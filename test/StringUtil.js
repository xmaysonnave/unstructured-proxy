const StringUtilMock = artifacts.require("StringUtilMock");

contract("StringUtil", function ([_, anyone]) {

    it("append", async () => {
        const test = await StringUtilMock.new({ from: anyone });
        (await test.appendTest()).should.be.equal(true);
    });

});
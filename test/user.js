var User = artifacts.require("./User.sol");

contract('User', function(accounts) {

  it('Should test all props as owner', () => {
    var user;
    function getFuncsAndParams() {
      return [
        [user.getEmail, user.setEmail, 'test@gmail.com'],
        [user.getName, user.setName, 'martin'],
        [user.getCountry, user.setCountry, 'NO'],
        [user.getDescription, user.setDescription, 'test-description'],
        [user.getDateOfBirth, user.setDateOfBirth, '10/08/1991'],
        [user.getGender, user.setGender, 'male'],
        [user.getIsPublic, user.setIsPublic, false]
      ]
    };
    return User.deployed().then(instance => {
      user = instance;
      const funcs = getFuncsAndParams();
      return Promise.all(funcs.map(f => {
        return f[1](f[2]).then(() => f[0].call()).then(res => {
          const [value, lastUpdated, writer] = res;
          assert.equal(value, f[2], `${f[2]} is not updated.`);
          return value
        });
      }));
    }).catch(assert.fail)
  });

  it('Should block read with accounts[1] as reader', () => {
    var user;
    return User.deployed().then(res => {
      user = res;
      return user.getEmail.call({ from: accounts[1]})
    }).catch(err => {
      assert(err.message.indexOf('invalid opcode') > -1);
    })
  });

  it('Should set accounts[1] as reader of prop email', () => {
    var user;
    return User.deployed().then(res => {
      user = res;
      return user.setReadWriteAccess('email', 1, accounts[1])
    }).then(res => {
      return user.getEmail.call({ from: accounts[1] })
    }).then(res => {
      assert.equal(res[0].valueOf(), 'test@gmail.com');
      assert.equal(res[2], accounts[0]);
    }).catch(err => {
      assert.fail(err.message);
    })
  });
});

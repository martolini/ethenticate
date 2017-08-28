pragma solidity ^0.4.15;

contract User {

	struct Meta {
		address writer;
		uint lastUpdated;
	}

	enum ReadWriteFlag { None, Read, Write }

	address owner;
	string name;
	string email;
	string country;
	string description;
	string dateOfBirth;
	string gender;
	string public username;
	bool isPublic;
	mapping (address => bool) _signers;
	mapping (address => mapping (string => ReadWriteFlag)) readWriteMap;
	mapping (string => Meta) meta;

	function User() {
		owner = msg.sender;
		isPublic = false;
	}

	modifier ownerOnly() {
		require(msg.sender == owner);
		_;
	}

	modifier hasReadAccess(string field) {
		require(isPublic || readWriteMap[msg.sender][field] >= ReadWriteFlag.Read || msg.sender == owner);
		_;
	}

	modifier hasWriteAccess(string field) {
		require(readWriteMap[msg.sender][field] == ReadWriteFlag.Write || msg.sender == owner);
		_;
	}

	function updateMeta(string field) internal {
		var m = meta[field];
		m.lastUpdated = now;
		m.writer = msg.sender;
	}

	function getName() hasReadAccess('name') constant returns (string, uint, address) {
		var m = meta['name'];
		return (name, m.lastUpdated, m.writer);
	}

	function getEmail() hasReadAccess('email') constant returns (string, uint, address) {
		var m = meta['email'];
		return (email, m.lastUpdated, m.writer);
	}

	function getCountry() hasReadAccess('country') constant returns (string, uint, address) {
		var m = meta['country'];
		return (country, m.lastUpdated, m.writer);
	}

	function getDescription() hasReadAccess('description') constant returns (string, uint, address) {
		var m = meta['description'];
		return (description, m.lastUpdated, m.writer);
	}

	function getDateOfBirth() hasReadAccess('dateOfBirth') constant returns (string, uint, address) {
		var m = meta['dateOfBirth'];
		return (dateOfBirth, m.lastUpdated, m.writer);
	}

	function getGender() hasReadAccess('gender') constant returns (string, uint, address) {
		var m = meta['gender'];
		return (gender, m.lastUpdated, m.writer);
	}

	function getIsPublic() hasReadAccess('isPublic') constant returns (bool, uint, address) {
		var m = meta['isPublic'];
		return (isPublic, m.lastUpdated, m.writer);
	}

	function setReadWriteAccess(string field, uint readWrite, address addr) ownerOnly {
		ReadWriteFlag f = ReadWriteFlag(readWrite);
		readWriteMap[addr][field] = f;
	}

	function setName(string newName) hasWriteAccess('name') {
		updateMeta('name');
		name = newName;
	}

	function setEmail(string newEmail) hasWriteAccess('email') {
		updateMeta('email');
		email = newEmail;
	}

	function setCountry(string newCountry) hasWriteAccess('country') {
		updateMeta('country');
		country = newCountry;
	}

	function setDescription(string newDescription) hasWriteAccess('description') {
		updateMeta('description');
		description = newDescription;
	}

	function setDateOfBirth(string newDateOfBirth) hasWriteAccess('dateOfBirth') {
		updateMeta('dateOfBirth');
		dateOfBirth = newDateOfBirth;
	}

	function setGender(string newGender) hasWriteAccess('gender') {
		updateMeta('gender');
		gender = newGender;
	}

	function setIsPublic(bool newIsPublic) hasWriteAccess('isPublic') {
		updateMeta('isPublic');
		isPublic = newIsPublic;
	}
}

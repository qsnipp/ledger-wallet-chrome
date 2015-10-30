@ledger.crypto ?= {}

# Wrapper around Stanford AES Library for encyrpt/decrypt data with AES
class @ledger.crypto.AES

  constructor: (@key, iv = '554f0cafd67ddcaa', salt = '846cea3ae6a33474d6ae2221d8563eaaba73ef9ea20e1803') ->
    @_params =
      v: 1
      iter: 1000
      ks: 256
      ts: 128
      mode: 'ccm'
      adata: ''
      cipher: 'aes'
      iv: sjcl.codec.base64.toBits(iv)
      salt: sjcl.codec.base64.toBits(salt)

  # Encrypts the given string using AES-256
  # @param [String] data Data to encrypt
  encrypt: (data) ->
    sjcl.codec.base64.fromBits(@rawEncrypt(data), 0)

  # Decrypts the given encrypted data
  # @param [String] encryptedData An encrypted string
  decrypt: (encryptedData) ->
    @rawDecrypt(sjcl.codec.base64.toBits(encryptedData))

  rawEncrypt: (data) ->
    crypted = sjcl.json._encrypt(@key, data, @_params).ct
    for value, index in crypted
      crypted[index] = value >>> 0
    crypted


  rawDecrypt: (data) ->
    params = _.clone(@_params)
    params.ct = data
    sjcl.json._decrypt(@key, params)
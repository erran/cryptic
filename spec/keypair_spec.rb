require 'cryptic/keypair'

describe Cryptic::Keypair do
  let :private_keys do
    keys = [
      './cryptic_private.pem',
      File.read('./cryptic_private.pem')
    ]

    # Repeat the keys for zipping
    keys *= 2
  end

  let :public_keys do
    keys = [
      './cryptic_public.pem',
      File.read('./cryptic_public.pem')
    ]

    # Repeat the keys in opposing order for zipping
    keys += keys.reverse
  end

  it 'should be able to create a keypair from a private key' do
    private_keys.uniq.each do |private_key|
      expect {
        Cryptic::Keypair.new(
          private_key,
          passphrase: 'P4$SpHr4z3'
        )
      }.to_not raise_error
    end
  end

  it 'should be able to create a keypair from a private key and a public key' do
    private_keys.zip(public_keys).each do |private_key, public_key|
      expect {
        Cryptic::Keypair.new(
          private_key,
          passphrase: 'P4$SpHr4z3',
          public_key: public_key
        )
      }.to_not raise_error
    end
  end

  # TODO: Add custom error classes below once implemented

  it 'should not be able to create a keypair with an empty private key' do
    expect { Cryptic::Keypair.new('') }.to raise_error
    expect { Cryptic::Keypair.new(nil) }.to raise_error
  end

  it 'should not be able to create a keypair with an invalid private key' do
    public_keys.uniq.each do |public_key|
      expect {
        Cryptic::Keypair.new(
          public_key,
          passphrase: 'P4$SpHr4z3'
        )
      }.to raise_error

      expect { Cryptic::Keypair.new(public_key) }.to raise_error
    end

    expect { Cryptic::Keypair.new('invalid') }.to raise_error
  end

  it 'should not be able to create a keypair with an invalid passphrase' do
    private_keys.uniq.each do |private_key|
      expect {
        Cryptic::Keypair.new(
          private_key,
          passphrase: 'BadPassphrase'
        )
      }.to raise_error
    end
  end
end

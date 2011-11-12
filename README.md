# KeySMS Ruby gem

The KeySMS gem is a Ruby gem for sending SMS messages through the Norwegian SMS gateway, [KeySMS][official].

If you just need to run the gem, it's much easier just to [install the gem][gem]:

> gem install keysms

[official]: http://keysms.no
[gem]: https://rubygems.org/gems/keysms

## Requirements

In order to use KeySMS, you need to register as a user and get an API key from KeySMS.

## Usage

To send an SMS:

 * Create a new instance of the SMS sender: `sms = Keysms::SMS.new`
 * Authenticate using your username and API key: `sms.authenticate(username, key)`
 * Send your message: `sms.send(your_message, receivers)`

Receivers can either be a single phone number (string) or a list of receivers.

### Errors

KeySMS will raise an exception if something goes wrong:

 * NoValidReceiversError: If one or more of the receivers isn't a valid phone number.
 * NotAuthenticatedError: If either your username or API key isn't recognized by the gateway.
 * SMSError: General exception in case of unhandled/unknown errors.

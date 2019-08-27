ruleset lab2_twilio {
  meta {
    use module lab2_keys
    use module twilio alias twilio
        with account_sid = keys:twilio{"account_sid"}
             auth_token =  keys:twilio{"auth_token"}
    shares __testing
  }

  global {
    __testing = { "events": [ { "domain": "test", "type": "messages" } ] }
  }

  rule test_send_sms {
    select when test new_message
    twilio:send_sms(event:attr("to"),
                    event:attr("from"),
                    event:attr("message")
                   )
  }
  rule test_messages {
    select when test messages
    pre {
      twilio:messages(event:attr("to"),
                      event:attr("from")) setting(messageresult)

    }

    always {
      messageresult.klog()
      filterTo.klog()
      filterToAndFrom.klog()
    }
  }
}

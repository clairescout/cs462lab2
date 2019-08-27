ruleset twilio {
  meta {
    configure using account_sid = ""
                    auth_token = ""
    provides
        send_sms, messages
  }

  global {
    send_sms = defaction(to, from, message) {
       base_url = <<https://#{account_sid}:#{auth_token}@api.twilio.com/2010-04-01/Accounts/#{account_sid}/>>
       http:post(base_url + "Messages.json", form = {
                "From":from,
                "To":to,
                "Body":message
            })
    }

    messages = function(to, from, pagenumber) {
      base_url = <<https://#{account_sid}:#{auth_token}@api.twilio.com/2010-04-01/Accounts/#{account_sid}/Messages.json/>>;
      messageresult = http:get(base_url){"content"}.decode(){"messages"};

      // // Filter result based on parameters
      to = (to.length() > 0) => "+" + to | to;
      from = (from.length() > 0) => "+" + from | from;
      filterTo = (to.length() > 1) => messageresult.filter(function(x) {x{"to"} == to}) | messageresult;
      filterToAndFrom = (from.length() > 1) => filterTo.filter(function(x) {x{"from"} == from}) | filterTo;
      filterToAndFrom

    }

  }
}

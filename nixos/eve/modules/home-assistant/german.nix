{
  services.home-assistant.config = let
    counter = name: {
      inherit name;
      min = 0;
      max = 999;
      step = 1;
      icon = "mdi:book";
    };
  in {
    ios.push.categories = [{
      name = "Learn German";
      identifier = "learn_german";
      actions = [{
        identifier = "DONE_DUOLINGO";
        title = "Duolingo :)";
        activationMode = "background";
      } {
        identifier = "DONE_GRAMMAR";
        title = "Grammar :)";
        activationMode = "background";
      } {
        identifier = "DONE_BOOK";
        title = "Book :)";
        activationMode = "background";
      } {
        identifier = "DONE_PODCAST";
        title = "Podcast :)";
        activationMode = "background";
      } {
        identifier = "DONE_SPEAKING";
        title = "Speaking :)";
        activationMode = "background";
      }];
    }];
    input_number.german_streak_days = counter "German learning streak";
    input_number.done_duolingo = counter "Days Duolingo";
    input_number.done_grammar = counter "Days grammar";
    input_number.done_book = counter "Days book";
    input_number.done_podcast = counter  "Days podcast";
    input_number.done_speaking = counter "Days speaking";
    input_boolean.learned_german_today = {
      name = "Learned German today";
      icon = "mdi:book";
    };
    automation = let
      doneAutomation = name: id: {
        alias = name;
        trigger = {
          platform = "event";
          event_type = "ios.notification_action_fired";
          event_data.actionName = id;
        };
        action = [{
          service = "input_number.increment";
          entity_id = "input_number.german_streak_days";
        } {
          service = "input_number.increment";
          entity_id = "input_number.${id}";
        } {
          service = "input_boolean.turn_on";
          entity_id = "input_boolean.learned_german_today";
        } {
          service = "notify.pushover";
          data_template.message = ''
            Shannan ${name} today.
          '';
        } {
          service = "notify.mobile_app_beatrice";
          data_template.message = "Great your German streak is at {{input_number.german_streak_days}} days!";
        }];
      };
      reminder = time: {
        alias = "German reminder at ${time}";
        trigger = {
          platform = "time";
          at = time;
        };
        action = [{
          service = "notify.mobile_app_beatrice";
          data_template = {
            title = "Hey Shannan!";
            message = ''
              How about some German today? (current streak: {{states("input_number.german_streak_days")}} days)
            '';
            data.push.category = "learn_german";
          };
        } {
          service = "notify.pushover";
          data_template.message = ''
            Remind Shannan to do German (current streak: {{states("input_number.german_streak_days")}} days)
          '';
        }];
        condition = {
          condition = "state";
          entity_id = "input_boolean.learned_german_today";
          state = "off";
        };
    }; in [
      (reminder "13:35:00")
      (reminder "18:05:00")
      (doneAutomation "done Duolingo" "DONE_DUOLINGO")
      (doneAutomation "done grammar" "DONE_GRAMMAR")
      (doneAutomation "done speaking" "DONE_SPEAKING")
      (doneAutomation "read a book" "DONE_BOOK")
      (doneAutomation "listened podcast" "DONE_PODCAST")
      {
        alias = "Reset learned German today";
        trigger = {
          platform = "time";
          at = "00:00:01";
        };
        action = [{
          service = "input_boolean.turn_off";
          entity_id = "input_boolean.learned_german_today";
        }];
        condition = {
          condition = "state";
          entity_id = "input_boolean.learned_german_today";
          state = "on";
        };
      } {
        alias = "Break German learning streak";
        trigger = {
          platform = "time";
          at = "00:00:01";
        };
        action = let
          msg = "German learning streak broke after {{input_number.german_streak_days}} days :(";
        in [{
          service = "notify.mobile_app_beatrice";
          data_template.message = msg;
        } {
          service = "notify.pushover";
          data_template.message = msg;
        } {
          service = "input_number.set_value";
          entity_id = "input_number.german_streak_days";
          data.value = 0;
        }];
        condition = {
          condition = "state";
          entity_id = "input_boolean.learned_german_today";
          state = "off";
        };
    }];
  };
}

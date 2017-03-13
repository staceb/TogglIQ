using Toybox.System as Sys;
using Toybox.Time as Time;

module Toggl {
    enum {
        TIMER_STATE_RUNNING,
        TIMER_STATE_STOPPED
    }

    enum {
        TIMER_WARNING_NONE,
        TIMER_WARNING_NO_API_KEY,
        TIMER_WARNING_NO_NETWORK
    }

    class TogglTimer {
        hidden var _togglTimer;
        hidden var _onPropertyChanged;
        hidden var _startMoment;
        hidden var _warnings;

        function initialize() {
            _togglTimer = null;
            _warnings = {};
        }

        function setTimer( togglTimer ) {
            _togglTimer = togglTimer;

            if(_togglTimer != null) {
                // Time string is in ISO8601 format:
                // YYYY-MM-DDTHH:MM:SS
                var timeStr = _togglTimer["start"];
                _startMoment = Time.Gregorian.moment({
                    :year => timeStr.substring(0, 4).toNumber(),
                    :month => timeStr.substring(5, 7).toNumber(),
                    :day => timeStr.substring(8, 10).toNumber(),
                    :hour => timeStr.substring(11, 13).toNumber(),
                    :minute => timeStr.substring(14, 16).toNumber(),
                    :second => timeStr.substring(17, 19).toNumber()
                });
            }
        }

        function setWarning( warning ) {
            if(!_warnings.hasKey(warning)) {
                _warnings.put(warning, true);
            }
        }

        function clearWarning( warning ) {
            if(_warnings.hasKey(warning)) {
                _warnings.remove(warning);
            }
        }

        //! Retrieves the state of the Timer
        function getTimerState() {
            if( _togglTimer != null ) {
                return Toggl.TIMER_STATE_RUNNING;
            }

            return Toggl.TIMER_STATE_STOPPED;
        }

        //! Retrives the Duration of the Active Timer
        //! @returns [Time.Duration] The duration of the active timer,
        //!     null if there is no active task
        function getTimerDuration() {
            if( _togglTimer != null ) {
                return Time.now().subtract(_startMoment);
            }

            return null;
        }

        //! Retrieves a string representing the active task
        //! @returns [String] Representing the active task, null
        //!     if there is no active task
        function getActiveTaskString() {
            if( _togglTimer != null ) {
                return _togglTimer["description"];
            }
            return null;
        }

        function getTimer() {
            return _togglTimer;
        }

        function getWarnings() {
            return _warnings;
        }
    }
}
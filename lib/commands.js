// Generated by LiveScript 1.2.0
(function(){
  var _, getParameters, getShortcuts, getDefaults, isParameter, isShortcut, parse, parseArguments, parameterSubstr, parseParameter, parseShortcut, expandShortcut, help, out$ = typeof exports != 'undefined' && exports || this, slice$ = [].slice;
  _ = require('prelude-ls');
  getParameters = function(rules){
    return _.Obj.keys(rules);
  };
  getShortcuts = function(rules){
    return _.Obj.values(
    _.Obj.map(function(rule){
      return rule.shortcut;
    })(
    _.Obj.filter(function(rule){
      return rule.shortcut !== undefined;
    })(
    rules)));
  };
  getDefaults = function(rules){
    return _.Obj.map(function(rule){
      return rule['default'];
    })(
    rules);
  };
  isParameter = curry$(function(rules, parameter){
    return in$(parameter, getParameters(rules));
  });
  isShortcut = curry$(function(rules, shortcut){
    return in$(shortcut, getShortcuts(rules));
  });
  out$.parse = parse = curry$(function(rules, argv){
    return parseArguments(rules, isParameter(rules), isShortcut(rules), argv);
  });
  parseArguments = curry$(function(rules, isParameter, isShortcut, arg$){
    var parameter, argument, rest, parsedParameter, parser, parsedArguments;
    parameter = arg$[0], argument = arg$[1], rest = slice$.call(arg$, 2);
    switch (false) {
    case parameter !== undefined:
      return getDefaults(rules);
    default:
      parsedParameter = parseParameter(isParameter, parameter) || expandShortcut(rules, parseShortcut(isShortcut, parameter)) || (function(){
        throw new Error('Parameter \'' + parameter + '\' does not exist.');
      }());
      parser = parseArguments(rules, isParameter, isShortcut);
      if (parseParameter(isParameter, argument) || parseShortcut(isShortcut, argument)) {
        parsedArguments = parser([argument].concat(rest));
        parsedArguments[parsedParameter] = parsedArguments[parsedParameter] || true;
      } else {
        parsedArguments = parser(rest);
        parsedArguments[parsedParameter] = argument === undefined ? parsedArguments[parsedParameter] || true : argument;
      }
      return parsedArguments;
    }
  });
  parameterSubstr = curry$(function(f, length, parameter){
    var parsed;
    switch (false) {
    case typeof parameter === 'string':
      return undefined;
    case !(parameter.length < length):
      return undefined;
    default:
      parsed = parameter.substr(length);
      if (f(parsed)) {
        return parsed;
      }
    }
  });
  parseParameter = curry$(function(isParameter, unparsedParameter){
    return parameterSubstr(isParameter, 2, unparsedParameter);
  });
  parseShortcut = curry$(function(isShortcut, unparsedShortcut){
    return parameterSubstr(isShortcut, 1, unparsedShortcut);
  });
  expandShortcut = function(rules, shortcut){
    switch (false) {
    case shortcut !== undefined:
      return undefined;
    default:
      return _.head(
      _.find(function(arg$){
        var parameter, rule;
        parameter = arg$[0], rule = arg$[1];
        return rule.shortcut === shortcut;
      })(
      _.Obj.objToPairs(
      rules)));
    }
  };
  out$.help = help = function(rules){
    var max, texts;
    max = 0;
    texts = _.map(function(arg$){
      var parameter, rule, parameters;
      parameter = arg$[0], rule = arg$[1];
      parameters = '--' + parameter + (rule.shortcut ? ', -' + rule.shortcut : '');
      max = Math.max(max, parameters.length);
      return [parameters, rule.description];
    })(
    _.Obj.objToPairs(
    rules));
    return _.foldl(function(acc, arg$){
      var parameters, description, text;
      parameters = arg$[0], description = arg$[1];
      if (description === undefined) {
        text = parameters;
      } else {
        text = parameters + _.Str.repeat(max - parameters.length + 1, ' ') + description;
      }
      return acc + (acc !== '' ? "\n" : '') + text;
    }, '')(
    texts);
  };
  function in$(x, xs){
    var i = -1, l = xs.length >>> 0;
    while (++i < l) if (x === xs[i]) return true;
    return false;
  }
  function curry$(f, bound){
    var context,
    _curry = function(args) {
      return f.length > 1 ? function(){
        var params = args ? args.concat() : [];
        context = bound ? context || this : this;
        return params.push.apply(params, arguments) <
            f.length && arguments.length ?
          _curry.call(context, params) : f.apply(context, params);
      } : f;
    };
    return _curry();
  }
}).call(this);

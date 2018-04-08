# This file has been generated by node2nix 1.4.0. Do not edit!

{nodeEnv, fetchurl, fetchgit, globalBuildInputs ? []}:

let
  sources = {
    "adverb-where-0.0.9" = {
      name = "adverb-where";
      packageName = "adverb-where";
      version = "0.0.9";
      src = fetchurl {
        url = "https://registry.npmjs.org/adverb-where/-/adverb-where-0.0.9.tgz";
        sha1 = "09c5cddd8d503b9fe5f76e0b8dc5c70a8f193e34";
      };
    };
    "e-prime-0.10.2" = {
      name = "e-prime";
      packageName = "e-prime";
      version = "0.10.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/e-prime/-/e-prime-0.10.2.tgz";
        sha1 = "ea9375eb985636de88013c7a9fb129ad9e15eff8";
      };
    };
    "no-cliches-0.1.0" = {
      name = "no-cliches";
      packageName = "no-cliches";
      version = "0.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/no-cliches/-/no-cliches-0.1.0.tgz";
        sha1 = "f4eb81a551fecde813f8c611e35e64a5118dc38c";
      };
    };
    "object.assign-4.0.4" = {
      name = "object.assign";
      packageName = "object.assign";
      version = "4.0.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/object.assign/-/object.assign-4.0.4.tgz";
        sha1 = "b1c9cc044ef1b9fe63606fc141abbb32e14730cc";
      };
    };
    "passive-voice-0.1.0" = {
      name = "passive-voice";
      packageName = "passive-voice";
      version = "0.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/passive-voice/-/passive-voice-0.1.0.tgz";
        sha1 = "16ff91ae40ba0e92c43e671763fdc842a70270b1";
      };
    };
    "too-wordy-0.1.4" = {
      name = "too-wordy";
      packageName = "too-wordy";
      version = "0.1.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/too-wordy/-/too-wordy-0.1.4.tgz";
        sha1 = "8e7b20a7b7a4d8fc3759f4e00c4929993d1b12f0";
      };
    };
    "weasel-words-0.1.1" = {
      name = "weasel-words";
      packageName = "weasel-words";
      version = "0.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/weasel-words/-/weasel-words-0.1.1.tgz";
        sha1 = "7137946585c73fe44882013853bd000c5d687a4e";
      };
    };
    "function-bind-1.1.1" = {
      name = "function-bind";
      packageName = "function-bind";
      version = "1.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/function-bind/-/function-bind-1.1.1.tgz";
        sha512 = "38chm1mh077ksx6hy2sssfz4q29hf0ncb9k6ila7si54zqcpl5fxd1rh6wi82blqp7jcspf4aynr7jqhbsg2yc9y42xpqqp6c1jz2n8";
      };
    };
    "object-keys-1.0.11" = {
      name = "object-keys";
      packageName = "object-keys";
      version = "1.0.11";
      src = fetchurl {
        url = "https://registry.npmjs.org/object-keys/-/object-keys-1.0.11.tgz";
        sha1 = "c54601778ad560f1142ce0e01bcca8b56d13426d";
      };
    };
    "define-properties-1.1.2" = {
      name = "define-properties";
      packageName = "define-properties";
      version = "1.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/define-properties/-/define-properties-1.1.2.tgz";
        sha1 = "83a73f2fea569898fb737193c8f873caf6d45c94";
      };
    };
    "foreach-2.0.5" = {
      name = "foreach";
      packageName = "foreach";
      version = "2.0.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/foreach/-/foreach-2.0.5.tgz";
        sha1 = "0bee005018aeb260d0a3af3ae658dd0136ec1b99";
      };
    };
  };
in
{
  write-good = nodeEnv.buildNodePackage {
    name = "write-good";
    packageName = "write-good";
    version = "0.11.3";
    src = fetchurl {
      url = "https://registry.npmjs.org/write-good/-/write-good-0.11.3.tgz";
      sha512 = "0sqzdqlvhcf7qqqch5mjxv7ag9hlmkcw8sdg0gdwgk59d7z8nimh66d36aa03kby9jzdkf8aik6ncngddfjd3g1135k82vhxqf8hckw";
    };
    dependencies = [
      sources."adverb-where-0.0.9"
      sources."e-prime-0.10.2"
      sources."no-cliches-0.1.0"
      sources."object.assign-4.0.4"
      sources."passive-voice-0.1.0"
      sources."too-wordy-0.1.4"
      sources."weasel-words-0.1.1"
      sources."function-bind-1.1.1"
      sources."object-keys-1.0.11"
      sources."define-properties-1.1.2"
      sources."foreach-2.0.5"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "Naive linter for English prose";
      homepage = "https://github.com/btford/write-good#readme";
      license = "MIT";
    };
    production = true;
  };
}
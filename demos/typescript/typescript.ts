/// <reference path="assets/js/google-closure/closure/goog/base.js"/>
//goog.provide('este.demos.Greeter')

module este.demos {
  export class Greeter {
    greeting: string;
    constructor (message: string) {
      this.greeting = message;
    }
    greet() {
      return "Hello, " + this.greeting;
    }
  }
}
var greeter = new este.demos.Greeter("world");


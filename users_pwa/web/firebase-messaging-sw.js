// Import SDK
importScripts("https://www.gstatic.com/firebasejs/8.4.3/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.4.3/firebase-messaging.js");


firebase.initializeApp({
    apiKey: "AIzaSyBviKclYQk2KFXHN-SuBBw9OCJEB7JyqjY",
    authDomain: "payacprnotifi.firebaseapp.com",
    projectId: "payacprnotifi",
    storageBucket: "payacprnotifi.appspot.com",
    messagingSenderId: "101311359139",
    appId: "1:101311359139:web:a00c0d46074422f9ab7716",
    measurementId: "G-E5SYCWMKZ8"
});

const messaging = firebase.messaging();
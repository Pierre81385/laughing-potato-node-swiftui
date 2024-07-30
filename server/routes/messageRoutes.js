const router = require("express").Router();
const Message = require("../models/Message");
const mongoose = require("mongoose");

//read all
router.route("/").get((req, res) => {
    Message.find()
      .then((messages) => {
        res.status(200).json(messages)
        console.log(JSON.stringify(messages))
})
      .catch((err) => res.status(400).json("Error: " + err));
  });

  module.exports = router;
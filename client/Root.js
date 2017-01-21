import React, { Component } from 'react'
import { View, Dimensions } from 'react-native'
import { GiftedChat } from 'react-native-gifted-chat'
import moment from 'moment'
import Chat from './Chat'

const HOST = 'localhost'

// layout numbers
const SCREEN_HEIGHT = Dimensions.get('window').height
const STATUS_BAR_HEIGHT = 40  // i know, but let's pretend its cool
const CHAT_MAX_HEIGHT = SCREEN_HEIGHT - STATUS_BAR_HEIGHT

// yes, i'm 41 years old.
const NAMES = ['Girl', 'Boy', 'Horse', 'Poo', 'Face', 'Giant', 'Super', 'Butt', 'Captain', 'Lazer']
const getRandomInt = (min, max) => Math.floor(Math.random() * (max - min)) + min
const getRandomName = () => NAMES[getRandomInt(0, NAMES.length)]
const getRandomUser = () => `${ getRandomName() }${ getRandomName() }${ getRandomName() }`
const user = getRandomUser()
const isMe = (someUser) => user === someUser
const avatar = { uri: 'https://facebook.github.io/react/img/logo_og.png' }

class Root extends Component {

  constructor (props) {
    super(props)
    // bind our functions to the right scope
    this.onSend = this.onSend.bind(this)
    this.onReceive = this.onReceive.bind(this);
    // let's chat!
    this.chat = Chat(user, this.onReceive)
  }

  componentWillMount() {
    fetch('http://' + HOST + '/messages')
    .then(function(response) {
      return response.json();
    })
    .then((responseData) => {
        let messages = [];

        for (i=0; i<responseData.messages.length; i++) {
          messages.push({
            _id: responseData.messages[i]["id"],
            text: responseData.messages[i]["body"],
            createdAt: new Date(responseData.messages[i]["created_at"] * 1000),
            user: {
              _id: responseData.messages[i]["id"],
              name: responseData.messages[i]["user"],
              avatar: "https://facebook.github.io/react/img/logo_og.png"
            }
          });
        }

        this.setState({
          messages: messages
        })
    })
    .done();
  }

  onReceive(text) {
    if (isMe(text.user)) return;
    this.setState((previousState) => {
      return {
        messages: GiftedChat.append(previousState.messages, {
          _id: Math.round(Math.random() * 1000000),
          text: text.body,
          createdAt: new Date(),
          user: {
            _id: 2,
            name: text.user,
            // avatar: 'https://facebook.github.io/react/img/logo_og.png',
          },
        }),
      };
    });
  }

  // fires when we need to send a message
  onSend (messages = []) {
    this.chat.send(messages[0].text);
    this.setState((previousState) => {
      return {
        messages: GiftedChat.append(previousState.messages, messages),
      };
    });
  }

  // draw our ui
  render () {
    return (
      <GiftedChat
        messages={this.state.messages}
        ref='giftedChat'
        onSend={ this.onSend }
        maxHeight={ CHAT_MAX_HEIGHT }
        senderImage={ avatar }
        />
    )
  }

}

export default Root

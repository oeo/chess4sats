import {
  useState
  useEffect
} from 'react'

import {
  useLocation
  usePath
  useParams
} from 'react-router-dom'

import Error from './components/error.coffee'
import Header from './components/header.coffee'
import Footer from './components/footer.coffee'

import {
  Button
  Container
  Row
  Col
  Spinner
} from 'reactstrap'

axios = require 'axios'

Home = (props) -> (
  [error,set_error] = useState(false)
  [status,set_status] = useState('initial status')

  useEffect(->
    document.title = 'Play Chess for Bitcoin - chess4sats'
  )

  create_challnge = (=>

  )

  return (
    <div className="container">
      <Header/>

      <div className="row justify-content-center">
        <div className="col-lg-5 col-md-10 col-sm-12">
          <div className="text-center">
            <p>{status}</p>
            <p>
              Challenge your friends to a high-stakes
              game of <a href="https://www.lichess.org" target="_blank">Lichess</a> by
              wagering sats over the Lightning Network.
            </p>
          </div>
          <div className="mt-3 text-center">
            <Button
              size="lg"
              color="success"
              onClick={@create_challenge}
            >
              Create a challenge
            </Button>
          </div>
        </div>
      </div>

      <Footer/>
    </div>
  )
)

export default Home

###
  componentDidMount: (->
    document.title = 'Play Chess for Bitcoin - chess4sats'

    @state.query = require('querystring').parse(
      @props.location.search?.substr?(1) ? ''
    )

    @setState loaded:true
  )

  create_challenge: (->
    r = await axios({
      method: 'post'
      url: '/v0/challenge'
      data: {
        mins: 9
        incr: 4
      }
    })

    @setState {redirect:'/' + r.data._id}
  )

  render: (->
    if @state.error then return <Error message={@state.error}/>
    if @state.redirect then return <Navigate to={@state.redirect}/>
    if !@state.loaded then return <div/>

    <div className="container">
      <Header/>

      <div className="row justify-content-center">
        <div className="col-lg-5 col-md-10 col-sm-12">
          <div className="text-center">
            <p>
              Challenge your friends to a high-stakes
              game of <a href="https://www.lichess.org" target="_blank">Lichess</a> by
              wagering sats over the Lightning Network.
            </p>
          </div>
          <div className="mt-3 text-center">
            <Button
              size="lg"
              color="success"
              onClick={@create_challenge}
            >
              Create a challenge
            </Button>
          </div>
        </div>
      </div>

      <Footer/>
    </div>
  )

##
export default Home
###

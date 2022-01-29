import React, {
  useState
  useEffect
} from 'react'

import {
  usePath
  useParams
  useLocation
  useNavigate
} from 'react-router-dom'

import {
  Button
  Container
  Row
  Col
  Spinner
} from 'reactstrap'

axios = require 'axios'

Home = (props) -> (
  [working,set_working] = useState(false)
  navigate = useNavigate()

  useEffect(->
    document.title = 'Play Chess for Bitcoin - chess4sats'
  )

  create_challenge = (=>
    set_working true

    r = await axios({
      method: 'post'
      url: '/v1/challenge'
      data: {
        mins: 15
        incr: 5
      }
    })

    navigate '/' + r.data._id
  )

  return (
    <Row className="justify-content-center">
      <Col xs={12} md={10} lg={6}>
        <div className="text-center">
          <p>
            Challenge your friends to a high-stakes
            game of <a href="https://www.lichess.org" target="_blank">Lichess</a> by
            wagering sats using lightning.
          </p>
        </div>
        <div className="mt-4 text-center">
          <Button
            size="lg"
            color="success"
            onClick={create_challenge}
          >
            {
              if !working
                <span>Create challenge</span>
              else
                <Spinner
                  as="span"
                  animation="border"
                  size="sm"
                  role="status"
                  aria-hidden="true"
                />
            }
          </Button>
        </div>
      </Col>
    </Row>
  )
)

export default Home


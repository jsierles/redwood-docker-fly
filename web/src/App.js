import { AuthProvider } from '@redwoodjs/auth'
import netlifyIdentity from 'netlify-identity-widget'
import { FatalErrorBoundary, RedwoodProvider } from '@redwoodjs/web'
import { RedwoodApolloProvider } from '@redwoodjs/web/apollo'
import { isBrowser } from '@redwoodjs/prerender/browserUtils'
import FatalErrorPage from 'src/pages/FatalErrorPage'

import Routes from 'src/Routes'

import './scaffold.css'
import './index.css'

isBrowser && netlifyIdentity.init()

const App = () => (
  <FatalErrorBoundary page={FatalErrorPage}>
    <RedwoodProvider titleTemplate="%PageTitle | %AppTitle">
      <AuthProvider client={netlifyIdentity} type="netlify">
        <RedwoodApolloProvider>
          <Routes />
        </RedwoodApolloProvider>
      </AuthProvider>
    </RedwoodProvider>
  </FatalErrorBoundary>
)

if (typeof window !== 'undefined') {
  window.__REDWOOD__API_PROXY_PATH = process.env.API_PROXY_PATH
    ? process.env.API_PROXY_PATH
    : 'http://localhost:8911'
}
export default App

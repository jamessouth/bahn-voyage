@react.component
let make = (~on_Click, ~ ~children) => {

  <form className="w-4/5 m-auto relative">
    <fieldset className="flex flex-col items-center justify-around h-72"> {children} </fieldset>
    <div className="absolute left-1/2 transform -translate-x-2/4 bottom-10">
      {switch (submitted, String.length(error) == 0) {

        |(false,false) => <p> {React.string(error)} </p>
        |(false,true) => React.null
        |(true,true) => 
        |(true,false) => 



      | false => React.null
      | true =>
        switch String.length(error) == 0 {
        | true => <Loading label="..." />
        | false => 
        }
      }}
    </div>
    <Button onClick>
    //   onClick={_ => {
    //     on_Click()
    //   }}>
      {React.string("submit")}
    </Button>
  </form>
}

//  switch String.length(error) == 0 {
//         | true => <Loading label="..." />
//         | false => {
//             setSubmitClicked(_ => false)
//             <p> {React.string(error)} </p>
//           }
//         }
